//
//  AddTeachersViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 9/4/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class AddTeachersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpTeachersArray()
        
        print("View has loaded :)")
    }
    
    //references
    @IBOutlet weak var saveButtonRef: UIButton!
    
    //function to set up elements
    func setUpElements() {
        
        //save button
        saveButtonRef.layer.cornerRadius = 15
        
        //table view
        self.addTeachersTableView.backgroundColor = UIColor.clear
        self.addTeachersTableView.allowsMultipleSelection = true
    }
    
    //array to display teachers
    var teachersArray: [String] = []
    //setting up the teacher directory
    func setUpTeachersArray() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            db.collection("Users").document(uid).getDocument { (userDocument, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    if let doc = userDocument {
                        let userSchool: String? = (doc.get("School") as? [String])?.joined(separator: ", ")
                        if let school = userSchool {
                            db.collection("Admins").document(school).getDocument { (adminDocument, error) in
                                if let error = error {
                                    print("There was an error: \(error.localizedDescription)")
                                } else {
                                    if let doc = adminDocument {
                                        let schoolStaff = doc.get("Staff") as? [String]
                                        self.teachersArray = schoolStaff?.sorted() ?? ["Teachers have not yet been added"]
                                        self.addTeachersTableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //array to save user selection
    var selectedTeachersArray: [String] = []
    
    //function to transition to profile page
    func transitionToProfile() {
        let profileVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.profileViewController) as? ProfileViewController
        self.view.window?.rootViewController = profileVC
        self.view.window?.makeKeyAndVisible()
    }
    
    //reference to the table view
    @IBOutlet weak var addTeachersTableView: UITableView!
    
    //table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teachersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addTeachersCell")
        cell?.textLabel?.text = self.teachersArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teacher = self.teachersArray[indexPath.row]
        self.selectedTeachersArray.append(teacher)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let teacher = self.teachersArray[indexPath.row]
        let teacherIndex = self.selectedTeachersArray.firstIndex(of: teacher)!
        self.selectedTeachersArray.remove(at: teacherIndex)
    }
    
    //save selection
    @IBAction func save(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            db.collection("Users").document(uid).updateData(["Teachers" : self.selectedTeachersArray]) { (error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    self.transitionToProfile()
                }
            }
        }
    }
}
