//
//  AddTeachersViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 8/13/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class ChangeTeachersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTeachersArray()
        self.addedTeacherLabel.alpha = 0
        self.addedTeachersTableView.backgroundColor = UIColor.clear
        self.addedTeachersTableView.allowsSelection = false
        print("View has loaded :)")
    }
    
    //coding the green add color
    let green = UIColor.init(red: 0/255, green: 164/255, blue: 35/255, alpha: 1)
    
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
                                        self.addedTeachersTableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //references
    @IBOutlet weak var addedTeachersTableView: UITableView!
    @IBOutlet weak var addedTeacherLabel: UILabel!

    //table view for added teachers
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "changeTeachersCell")
        cell?.textLabel?.text = teachersArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addTeacher = UIContextualAction(style: .normal, title: "Add") { (action, view, handler) in
            let teacher = self.teachersArray[indexPath.row]
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let db = Firestore.firestore()
                db.collection("Users").document(uid).updateData(["Teachers" : FieldValue.arrayUnion([teacher])]) { (error) in
                    if let error = error {
                        print("There was an error: \(error.localizedDescription)")
                    } else {
                        self.addedTeacherLabel.text = "\(teacher) was added to your teachers!"
                        self.addedTeacherLabel.alpha = 1
                        tableView.reloadData()
                    }
                }
            }
        }
        
        addTeacher.backgroundColor = green
        let add = UISwipeActionsConfiguration(actions: [addTeacher])
        return add
    }
    
}
