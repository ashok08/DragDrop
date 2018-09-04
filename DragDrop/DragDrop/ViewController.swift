//
//  ViewController.swift
//  DragDrop
//
//  Created by Ameer Hamja on 03/09/18.
//  Copyright © 2018 Ameer Hamja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    
    var numbers = ["1","2","3","4","5","6","7","8","9","0"]
    var alpabets = ["A","B","C","D","E","F","G","H","I","J"]
    var special = ["!","@","#","$","%","^","&","*","(",")"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register UITableviewCell nib.
        let nib1 = UINib(nibName: "demoTableViewCell", bundle: nil)
        self.tableView1.register(nib1, forCellReuseIdentifier: "demoTableViewCell")
        let nib2 = UINib(nibName: "demoTableViewCell", bundle: nil)
        self.tableView2.register(nib2, forCellReuseIdentifier: "demoTableViewCell")
        let nib3 = UINib(nibName: "demoTableViewCell", bundle: nil)
        self.tableView3.register(nib3, forCellReuseIdentifier: "demoTableViewCell")
       
        self.tableView3.delegate = self
        self.tableView3.dataSource = self
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        
        
        //enabling drag user interaction for UITableview.
        self.tableView1.dragInteractionEnabled = true
        self.tableView2.dragInteractionEnabled = true
        self.tableView3.dragInteractionEnabled = true
        
        //initialize UITableview drag & drop delegate.
        self.tableView1.dragDelegate = self
        self.tableView1.dropDelegate = self
        self.tableView2.dragDelegate = self
        self.tableView2.dropDelegate = self
        self.tableView3.dragDelegate = self
        self.tableView3.dropDelegate = self
        
        self.tableView1.tag = 0
        self.tableView2.tag = 1
        self.tableView3.tag = 2
  
        
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate,UITableViewDropDelegate{
    
     // MARK: UITableviewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag{
        case 0:
        return numbers.count
        case 1:
        return alpabets.count
        case 2:
        return special.count
        default:
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoTableViewCell", for: indexPath) as! demoTableViewCell
        switch tableView.tag{
        case 0:
            cell.label.text = self.numbers[indexPath.row]
        case 1:
            cell.label.text = self.alpabets[indexPath.row]
        case 2:
            cell.label.text = self.special[indexPath.row]
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    
    // MARK: UITableViewDragDelegate
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = self.dragItem(forPhotoAt: indexPath, tableview:tableView )
        return [dragItem]
    }
    private func dragItem(forPhotoAt indexPath: IndexPath, tableview: UITableView) -> UIDragItem {
        
        var string = String()
         switch tableview.tag{
         case 0:
           string = self.numbers[indexPath.row]
         case 1:
           string = self.alpabets[indexPath.row]
         case 2:
           string = self.special[indexPath.row]
         default:
           string = ""
        }
        let itemProvider = NSItemProvider(object: string as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return dragItem
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return previewParameters(forItemAt:indexPath,tableView: tableView)
    }
    /// Helper method
    private func previewParameters(forItemAt indexPath:IndexPath,tableView:UITableView) -> UIDragPreviewParameters?     {
        let cell = tableView.cellForRow(at: indexPath) as! demoTableViewCell
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(rect: cell.frame)
        return previewParameters
    }
    
    // MARK: UITableViewDropDelegate
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let string = items as? [String] else { return }
            var indexPaths = [IndexPath]()
            for (index, value) in string.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                switch tableView.tag{
                case 1:
                self.alpabets.insert(value, at: indexPath.row)
                if self.numbers.contains(value){
                 self.numbers =  self.numbers.filter {$0 != value}
                 self.tableView1.reloadData()
                }else{
                self.special =  self.special.filter {$0 != value}
                self.tableView3.reloadData()
                }
                case 0:
                self.numbers.insert(value, at: indexPath.row)
                if self.alpabets.contains(value){
                 self.alpabets =  self.alpabets.filter {$0 != value}
                 self.tableView2.reloadData()
                }else{
                self.special =  self.special.filter {$0 != value}
                self.tableView3.reloadData()
                }
                case 2:
                self.special.insert(value, at: indexPath.row)
                if self.numbers.contains(value){
                self.numbers =  self.numbers.filter {$0 != value}
                self.tableView1.reloadData()
                }else{
                self.alpabets =  self.alpabets.filter {$0 != value}
                self.tableView2.reloadData()
                }
                default: break
                }
                indexPaths.append(indexPath)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

