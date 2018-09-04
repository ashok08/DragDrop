//
//  demoTableViewCell.swift
//  DragDrop
//
//  Created by Ameer Hamja on 03/09/18.
//  Copyright © 2018 Ameer Hamja. All rights reserved.
//

import UIKit

class demoTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
