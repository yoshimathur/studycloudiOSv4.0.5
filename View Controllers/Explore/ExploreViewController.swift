//
//  ExploreViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 8/17/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View has loaded :)")
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    //references
    @IBOutlet weak var navBar: UIView!
    
    func setUpElements() {
        navBar.layer.borderWidth = 3
        navBar.layer.borderColor = Constants.Colors.studycloudblueCG
    }
    
}
