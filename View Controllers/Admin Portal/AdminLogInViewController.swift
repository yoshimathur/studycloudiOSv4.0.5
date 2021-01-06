//
//  AdminHomeViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 8/22/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class AdminLogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print("View has loaded :)")
    }
    
    //references
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var adminCodeTextField: UITextField!
    
    //variables to be carried over
    var school: String = ""
    
    //function to set up elements
    func setUpElements() {
        
        //making error label invisible
        errorLabel.alpha = 0
        
        //textfield
        adminCodeTextField.layer.borderWidth = 3
        adminCodeTextField.layer.borderColor = CGColor.init(srgbRed: 154/255, green: 191/255, blue: 1, alpha: 1)
        adminCodeTextField.layer.cornerRadius = 5
    }
    
    //continue button
    @IBAction func continueButton(_ sender: Any) {
        let code = adminCodeTextField.text
        if code?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorLabel.text = "Please enter a code!"
            errorLabel.alpha = 1
        } else if SchoolsData.adminCodes.contains(code!) == false {
            errorLabel.text = "Please enter a valid admin code!"
            errorLabel.alpha = 1
        } else {
            errorLabel.alpha = 0
            let db = Firestore.firestore()
            school = "School"
            
            print(school)
            db.collection("Admins").document(school).getDocument { (document, error) in
                if let document = document {
                    if document.exists {
                        print("Document exists")
                        self.performSegue(withIdentifier: "enterAdminHomeSegue", sender: self)
                    } else {
                        print("Document does not exist")
                        db.collection("Admins").document(self.school).setData(["Chat" : true, "Hours" : [0, 0], "HalfHours" : [0, 0], "Half Days" : [], "Holidays" : [], "Courses" : [], "Staff" : []])
                        self.performSegue(withIdentifier: "enterAdminHomeSegue", sender: self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterAdminHomeSegue" {
            let adminHome = segue.destination as! AdminHomeViewController
            adminHome.school = self.school
        }
    }
    
}
