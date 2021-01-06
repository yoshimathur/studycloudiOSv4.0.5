//
//  AdminHomeViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 9/3/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class AdminHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        print("View has loaded :)")
        // Do any additional setup after loading the view.
    }
    
    //variables to be carried over
    var school: String? = ""
    
    //references
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var chatControlButton: UIButton!
    @IBOutlet weak var courseControlButton: UIButton!
    @IBOutlet weak var staffControlButton: UIButton!
    
    //function to set up elements
    func setUpElements() {
        schoolLabel.text = self.school ?? "Could Not Get School - Please Exit and Log In Again!"
        
        chatControlButton.layer.cornerRadius = 10
        chatControlButton.layer.borderWidth = 2
        chatControlButton.layer.borderColor = CGColor(srgbRed: 154/255, green: 191/255, blue: 1, alpha: 1)
        
        courseControlButton.layer.cornerRadius = 10
        courseControlButton.layer.borderWidth = 2
        courseControlButton.layer.borderColor = CGColor(srgbRed: 154/255, green: 191/255, blue: 1, alpha: 1)
        
        staffControlButton.layer.cornerRadius = 10
        staffControlButton.layer.borderWidth = 2
        staffControlButton.layer.borderColor = CGColor(srgbRed: 154/255, green: 191/255, blue: 1, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adminChatControlSegue" {
            let chatControlVC = segue.destination as! AdminChatControlViewController
            chatControlVC.school = self.school
        } else if segue.identifier == "adminCourseControlSegue" {
            let courseControlVC = segue.destination as! AdminCourseControlViewController
            courseControlVC.school = self.school
        } else if segue.identifier == "adminStaffControlSegue" {
            let staffControlVC = segue.destination as! AdminStaffControlViewController
            staffControlVC.school = self.school
        }
    }
    
    
    

}
