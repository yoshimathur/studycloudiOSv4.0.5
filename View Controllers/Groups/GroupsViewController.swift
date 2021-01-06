//
//  StudyShareViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 10/8/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()

        print("View has loaded :)")
    }
    
    //references
    @IBOutlet weak var navBar: UIView!
    
    func setUpElements() {
        navBar.layer.borderWidth = 3
        navBar.layer.borderColor = Constants.Colors.studycloudblueCG
    }

}
