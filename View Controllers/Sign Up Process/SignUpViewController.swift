//
//  SignUpViewController.swift
//  TutorHub
//
//  Created by Yash Mathur on 3/4/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        print("View has loaded :)")
    }//View Did Load
    
    //references
    @IBOutlet weak var emailTextFieldForSignUp: UITextField!
    @IBOutlet weak var passwordTextFieldForSignUp: UITextField!
    @IBOutlet weak var confirmPasswordTextFieldForSignUp: UITextField!
    @IBOutlet weak var signUpButtonOnSignUpPageToGetToProfile: UIButton!
    @IBOutlet weak var errorLabelForSignUp: UILabel!
    @IBOutlet weak var schoolCodeTextField: UITextField!
    @IBOutlet weak var signUpButtonRef: UIButton!
    
    //function to set up the elements
    func setUpElements () {
        signUpButtonRef.layer.cornerRadius = 10
        errorLabelForSignUp.alpha = 0
    }//Set Up Elements
    
    //validate fields
    func validateFields() -> String? {
        
        //Check all fields are filled in
        if emailTextFieldForSignUp.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||  passwordTextFieldForSignUp.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextFieldForSignUp.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || schoolCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all the fields!"
        } //if
        
        //Check if email is valid
        let validEmail = emailTextFieldForSignUp.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(validEmail) == false {
            return "Please enter a valid email!"
        } //if
        
        //Check if password is secure
        let cleanedPassword = passwordTextFieldForSignUp.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Create a stronger password with at least 8 characters, a capital letter, and a number!"
        } //if
        
        //Check if the password matches the confirmed password
        let cleanedConfirmedPassword = confirmPasswordTextFieldForSignUp.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedPassword != cleanedConfirmedPassword {
            return "Passwords do not match!"
        } //if
        
        //Check if the code that is inputed is valid
        let code = schoolCodeTextField.text!
        if SchoolsData.schoolCodes.contains(code) == false {
            return "Please enter a valid school code!"
        } //if
        
        return nil
    }
    
    //This function will make the error label appear along with the corresponding error message 
    func showError(_ message: String) {
        errorLabelForSignUp.text = message
        errorLabelForSignUp.alpha = 1
    }
    
    @IBAction func signUpButtonToGetToProfileFromSignUp(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // This means there is something wrong and some error exists
            showError(error!)
        } else {

            // Create cleaned versions of the data - basically take out all white spaces from text fields
            let email = emailTextFieldForSignUp.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextFieldForSignUp.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in

                //Check for errors
                if err != nil {                    // There was an error creating the user
                    self.showError("Error creating user")
                    self.errorLabelForSignUp.text = err?.localizedDescription
                    self.errorLabelForSignUp.alpha = 1
                } else {
                    self.performSegue(withIdentifier: "signUpToEnterNameSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpToEnterNameSegue" {
            let VC = segue.destination as! EnterNameViewController
            VC.code = self.schoolCodeTextField.text!
        }
    }
}





