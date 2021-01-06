//
//  RequestHelpTableViewCell.swift
//  Study Cloud
//
//  Created by Yash Mathur on 7/8/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class RequestHelpTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    
}
