//
//  AdminCourseControlViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 9/4/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class AdminCourseControlViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpProgramArray()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print("View has loaded :)")
        // Do any additional setup after loading the view.
    }
    
    //variable to carry over school
    var school: String? = ""
    
    //array for program of studies
    var programOfStudies: [String] = []
    
    //references
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var programOfStudiesTableView: UITableView!
    
    //fucntion to set up elements
    func setUpElements() {
        
        //making error label invisible
        errorLabel.alpha = 0
        
        //curving enter button edges
        enterButton.layer.cornerRadius = 5
        
        //table view
        programOfStudiesTableView.allowsSelection = false
        programOfStudiesTableView.separatorColor = UIColor.init(named: "Study Cloud Button Color ")
    }
    
    //function to set up the inital program of studies array
    func setUpProgramArray() {
        if let school = school {
            let db = Firestore.firestore()
            db.collection("Admins").document(school).getDocument { (document, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    if let document = document {
                        self.programOfStudies = document.get("Courses") as! [String]
                        self.programOfStudiesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //enter course name
    @IBAction func enterCourseName(_ sender: Any) {
        if courseNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.errorLabel.text = "Please enter a valid course!"
            self.errorLabel.alpha = 1
        } else {
            let cleanedArray = self.programOfStudies.map({ $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) })
            if cleanedArray.contains(courseNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) {
                self.errorLabel.text = "Course has already been added to the Program of Studies!"
                self.errorLabel.alpha = 1
            } else {
                let course = courseNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                self.programOfStudies.append(course)
                self.programOfStudiesTableView.reloadData()
                self.courseNameTextField.text = ""
                self.errorLabel.alpha = 0
            }
        }
    }
    
    //save changes
    @IBAction func saveChanges(_ sender: Any) {
        if let school = school {
            let db = Firestore.firestore()
            db.collection("Admins").document(school).updateData(["Courses" : self.programOfStudies])
            self.performSegue(withIdentifier: "backToAdminHomeFromCourseControlSegue", sender: self)
        }
    }
    
    //table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.programOfStudies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminControlCoursesCell")
        cell!.textLabel?.text = self.programOfStudies[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let deletedCourse = self.programOfStudies[indexPath.row]
            let courseIndex = self.programOfStudies.firstIndex(of: deletedCourse)!
            self.programOfStudies.remove(at: courseIndex)
            self.programOfStudiesTableView.reloadData()
        }
        
        deleteAction.backgroundColor = UIColor.red
        let delete = UISwipeActionsConfiguration(actions: [deleteAction])
        return delete
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToAdminHomeFromCourseControlSegue" {
            let adminHome = segue.destination as! AdminHomeViewController
            adminHome.school = self.school
        }
    }
}
