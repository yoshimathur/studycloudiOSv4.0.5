//
//  AdminStaffControlViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 9/4/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class AdminStaffControlViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpDirectoryArray()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print("View has loaded :)")
        // Do any additional setup after loading the view.
    }

    //variable for carrying the school over
    var school: String? = ""

    //array for the teacher directory
    var teacherDirectory: [String] = []

    //references
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var teacherNameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var teacherDirectoryTableView: UITableView!

    
    //function to set up elements
    func setUpElements() {
        
        //make error label invisible
        errorLabel.alpha = 0
        
        //enter button shape
        enterButton.layer.cornerRadius = 5
        
        //tableview
        teacherDirectoryTableView.allowsSelection = false
        teacherDirectoryTableView.separatorColor = UIColor.init(named: "Study Cloud Button Color ")
    }
    
    //function to set up initial teachers directory
    func setUpDirectoryArray() {
        if let school = school {
            Firestore.firestore().collection("Admins").document(school).getDocument { (document, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    if let document = document {
                        self.teacherDirectory = document.get("Staff") as! [String]
                        self.teacherDirectoryTableView.reloadData()
                    }
                }
            }
        }
    }

    //enter teacher name
    @IBAction func enterTeacherName(_ sender: Any) {
        if self.teacherNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.errorLabel.text = "Please enter a valid teacher!"
            self.errorLabel.alpha = 1
        } else {
            let cleanedArray = self.teacherDirectory.map({ $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() })
            if cleanedArray.contains(teacherNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) {
                self.errorLabel.text = "Teacher has already been added to the Teacher Directory!"
                self.errorLabel.alpha = 1
            } else {
                let teacher = self.teacherNameTextField.text!
                self.teacherDirectory.append(teacher)
                self.teacherDirectoryTableView.reloadData()
                self.teacherNameTextField.text = ""
                self.errorLabel.alpha = 0
            }
        }
    }

    //save changes button
    @IBAction func saveChanges(_ sender: Any) {
        if let school = school {
            let db = Firestore.firestore()
            db.collection("Admins").document(school).updateData(["Staff" : self.teacherDirectory])
            self.performSegue(withIdentifier: "backToHomeFromStaffControlSegue", sender: self)
        }
    }

    //table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teacherDirectory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminControlTeachersCell")
        cell?.textLabel?.text = self.teacherDirectory[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let deletedTeacher = self.teacherDirectory[indexPath.row]
            let teacherIndex = self.teacherDirectory.firstIndex(of: deletedTeacher)!
            self.teacherDirectory.remove(at: teacherIndex)
            self.teacherDirectoryTableView.reloadData()
        }
        
        deleteAction.backgroundColor = UIColor.red
        let delete = UISwipeActionsConfiguration(actions: [deleteAction])
        return delete
    }

    
    //function to carry over school name
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToHomeFromStaffControlSegue" {
            let adminHome = segue.destination as! AdminHomeViewController
            adminHome.school = self.school
        }
    }
    
    

}
