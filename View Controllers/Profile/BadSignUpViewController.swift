//
//  BadSignUpViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 12/24/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class BadSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View has loaded :)")
    } //View Did Load
    
    //references
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButtonRef: UIButton!
    
    //function to set up the elements
    func setUpElements() {
        confirmButtonRef.layer.cornerRadius = 10
    } //Set Up Elements
    
    @IBAction func confirm(_ sender: Any) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email!, password: password!)
        
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            } else {
                user?.delete(completion: { (error) in
                    if let error = error {
                        print("There was an error: \(error.localizedDescription)")
                        
                        let badSignUpViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.badSignUpViewController) as? BadSignUpViewController
                        self.view.window?.rootViewController = badSignUpViewController
                        self.view.window?.makeKeyAndVisible()
                        
                    } else {
                        //account deleted
                        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.homeViewController) as? HomeViewController
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                    } //if-else
                }) //User Delete
            } //if-else
        }) //Reauthenticate
    } //Confirm Button Action
    
} //View Controller
