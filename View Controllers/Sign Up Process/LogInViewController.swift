//
//  LogInViewController.swift
//  TutorHub
//
//  Created by Yash Mathur on 3/4/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

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
    @IBOutlet weak var emailTextFieldForLogIn: UITextField!
    @IBOutlet weak var passwordTextFieldForLogIn: UITextField!
    @IBOutlet weak var logInButtonRef: UIButton!
    @IBOutlet weak var errorLabelForLogIn: UILabel!
    @IBOutlet weak var forgetPasswordButtonRef: UIButton!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var cancelPopUpButtonRef: UIButton!
    
    
    // Function visually sets up elements
    func setUpElements () {
    
        //log in button
        logInButtonRef.layer.cornerRadius = 10
    
        //keeping elements invisible
        errorLabelForLogIn.alpha = 0
        forgetPasswordButtonRef.alpha = 0
        transparentView.alpha = 0
        
        //forgot password pop up design
        popUpView.alpha = 0
        popUpView.layer.borderWidth = 3
        popUpView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        cancelPopUpButtonRef.layer.cornerRadius = 10
        cancelPopUpButtonRef.clipsToBounds = true
        cancelPopUpButtonRef.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cancelPopUpButtonRef.layer.borderWidth = 0.5
        popUpLabel.numberOfLines = 0
        popUpView.layer.cornerRadius = 10
}
    
    //log in button
    @IBAction func logInButtonToGetToProfileFromLogIn(_ sender: Any) {
        
        
        // create cleaned versions of the text field
        let email = emailTextFieldForLogIn.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextFieldForLogIn.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // signing in the user
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in

            if error != nil {
                // error signing in
                self.errorLabelForLogIn.text = error?.localizedDescription
                self.errorLabelForLogIn.alpha = 1
                self.passwordTextFieldForLogIn.text = ""
                self.forgetPasswordButtonRef.alpha = 1
            } else {
                let profileViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.profileViewController) as? ProfileViewController
                self.view.window?.rootViewController = profileViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    
    }
    
    //coding the forgot password button
    @IBAction func forgotPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: (emailTextFieldForLogIn.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.errorLabelForLogIn.text = error.localizedDescription
                self.errorLabelForLogIn.alpha = 1
            } else {
                self.transparentView.alpha = 1
                self.popUpView.alpha = 1
                self .popUpLabel.text = "An email to reset your password was sent to \(self.emailTextFieldForLogIn!.text!.trimmingCharacters(in: .whitespacesAndNewlines)). Check your email and follow the directions from there in order to reset your password."
            }
        }
    }
    
    //cancel the pop up 
    @IBAction func cancelPopUp(_ sender: Any) {
        setUpElements()
    }
    
}
 

