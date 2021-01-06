//
//  RequestTableViewCell.swift
//  Study Cloud
//
//  Created by Yash Mathur on 12/24/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
}
