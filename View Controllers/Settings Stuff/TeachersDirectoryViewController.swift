//
//  TeachersDirectoryViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 9/10/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class TeachersDirectoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTeachersArray()
        self.teachersDirectoryTableView.backgroundColor = UIColor.clear
        self.teachersDirectoryTableView.allowsSelection = false
        
        print("View has loaded :)")
        // Do any additional setup after loading the view.
    }
    
    //references
    @IBOutlet weak var teachersDirectoryTableView: UITableView!
    
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
                                        self.teachersDirectoryTableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teachersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teachersDirectoryCell")
        cell?.textLabel?.text = self.teachersArray[indexPath.row]
        return cell!
    }
    
    
    

}
