//
//  MessagingHomeTableViewCell.swift
//  Study Cloud
//
//  Created by Yash Mathur on 7/8/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class MessagingHomeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
}
