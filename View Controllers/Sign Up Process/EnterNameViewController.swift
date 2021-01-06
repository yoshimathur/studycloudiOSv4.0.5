//
//  EnterNameViewController.swift
//  Study Hall
//
//  Created by Yash Mathur on 5/4/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class EnterNameViewController: UIViewController {

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
    @IBOutlet weak var enterFullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButtonRef: UIButton!
    
    //function to set up the elements
    func setUpElements() {
        
        //save button
        saveButtonRef.layer.cornerRadius = 15
        
        //error label
        errorLabel.alpha = 0
    }
    
    //variable for the school code
    var code: String? = ""
    
    //function to transition to the select grade page
    func transitionToSelectGrade() {
        let newVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.selectGradeViewController) as? SelectGradeViewController
        self.view.window?.rootViewController = newVC
        self.view.window?.makeKeyAndVisible()
    }
    
    //using the save button
    @IBAction func saveFullNameButton(_ sender: Any) {
        if enterFullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorLabel.text = "Please fill out all information!"
            errorLabel.alpha = 1
        } else {
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let name = self.enterFullNameTextField.text!
                let number = self.phoneNumberTextField.text!
                
                //assinging name to user
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges(completion: { (error) in
                    if let error = error {
                        print("There was an error: \(error.localizedDescription)")
                        self.errorLabel.text = "Error saving user name!"
                        self.errorLabel.alpha = 1
                    } // if
                }) //Change Request
                
                if let code = code {
                    
                    let school: String = SchoolsData.schoolsByCodesDic[code]!
                    
                    //splicing the school into name, district and state
                    guard let spliceIndex = school.firstIndex(of: ",") else { errorLabel.text = "Error getting school information!"; errorLabel.alpha = 1; return }
                    let districtIndex = school.index(spliceIndex, offsetBy: 2)
                    let districtName = String(school.suffix(from: districtIndex))
                    
                    let districts = SchoolsData.schools.filter { (district: String) -> Bool in
                        return district.range(of: districtName, options: .caseInsensitive) != nil
                    }
                    guard let district: Int = SchoolsData.schools.firstIndex(of: districts.first!) else { return }
                    print(district)
                    
                    let db = Firestore.firestore()
                    db.collection("Users").document(uid).setData(["Name": name, "#" : number, "School" : code, "District" : district], merge: true)
                } else {
                    fatalError()
                } //if-else
                
                //going to the select school page
                self.transitionToSelectGrade()
            } //if
        } //if-else
    } //Save Full Name Button Button Action

}
