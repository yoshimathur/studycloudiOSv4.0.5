//
//  ChangeCourseViewController.swift
//  Study Hall
//
//  Created by Yash Mathur on 5/21/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class ChangeCourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpCoursesArray()
        
        print("View has loaded :)")
    }
    
    //coding the green add color
    let green = UIColor.init(red: 0/255, green: 164/255, blue: 35/255, alpha: 1)
    
    //references
    @IBOutlet weak var changeCoursesTableView: UITableView!
    @IBOutlet weak var courseAddedLabel: UILabel!
    @IBOutlet var subjectGroupButtons: [UIButton]!
    
    //function to set up the elements
    func setUpElements() {
        
        //error label
        self.courseAddedLabel.alpha = 0
        
        //subject group buttons
        for button in subjectGroupButtons {
            button.layer.cornerRadius = 10
            button.setTitleColor(.white, for: .disabled)
            button.setTitleColor(.black, for: .normal)
        }
        
        //disabling math button first
        subjectGroupButtons[0].backgroundColor = Constants.Colors.studycloudredUI
        subjectGroupButtons[0].isEnabled = false
        
        //table view
        self.changeCoursesTableView.backgroundColor = UIColor.clear
        self.changeCoursesTableView.allowsSelection = false
    }
    
    //array for the data
    var coursesArray: [String] = []
    //variable to control selected subject group
    var subjectGroup = "Math"
    //function to set up the courses
    func setUpCoursesArray() {
        switch subjectGroup {
        case "Math":
            self.coursesArray = Courses.mathCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "LAL":
            self.coursesArray = Courses.lalCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "Science":
            self.coursesArray = Courses.scienceCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "History":
            self.coursesArray = Courses.historyCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "Spanish":
            self.coursesArray = Courses.spanishCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "French":
            self.coursesArray = Courses.frenchCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "Italian":
            self.coursesArray = Courses.italianCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "German":
            self.coursesArray = Courses.germanCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "Japanese":
            self.coursesArray = Courses.japaneseCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "Chinese":
            self.coursesArray = Courses.chineseCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "Latin":
            self.coursesArray = Courses.latinCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        case "Elective":
            self.coursesArray = Courses.electiveCoursesArray
            self.changeCoursesTableView.reloadData()
            break
        default:
            self.coursesArray = Courses.fullCoursesArray
            self.changeCoursesTableView.reloadData()
        }
    }
    
    //necessary table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "changeCoursesCell")
        cell?.textLabel?.text = coursesArray[indexPath.row]
        return cell!
    }
    
    //swipe to add a course
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addCourseAction = UIContextualAction(style: .normal, title: "Add") { (action, view, handler) in
            let addedCourse = self.coursesArray[indexPath.row]
            let addedCourseIndex = Courses.fullCoursesArray.firstIndex(of: addedCourse)
            if let addedCourseIndex = addedCourseIndex {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let db = Firestore.firestore()
                    db.collection("Users").document(uid).updateData(["Courses" : FieldValue.arrayUnion([addedCourseIndex])]) { (error) in
                        if let error = error {
                            print("There was an error: \(error.localizedDescription)")
                        } else {
                            
                            //saving course addition to User Defaults
                            var savedCourses = UserDefaults.standard.array(forKey: "Courses") as! [String]
                            savedCourses.append(addedCourse)
                            savedCourses.sort()
                            UserDefaults.standard.setValue(savedCourses, forKey: "Courses")
                            
                            //display
                            tableView.reloadData()
                            self.courseAddedLabel.text = "\(addedCourse) was added to your courses!"
                            self.courseAddedLabel.alpha = 1
                        }
                    }
                }
            }
            
            self.courseAddedLabel.numberOfLines = 0
            print("Course was added")
        }
    
        addCourseAction.backgroundColor = self.green
        let addCourse = UISwipeActionsConfiguration(actions: [addCourseAction])
        return addCourse
    }
    
    //subject grouping buttons
    @IBAction func mathCourses(_ sender: Any) {
        self.subjectGroup = "Math"
        subjectGroupButtonSelect(0)
        self.setUpCoursesArray()
    }
    @IBAction func lalCourses(_ sender: Any) {
        self.subjectGroup = "LAL"
        self.subjectGroupButtonSelect(1)
        self.setUpCoursesArray()
    }
    @IBAction func scienceCourses(_ sender: Any) {
        self.subjectGroup = "Science"
        self.subjectGroupButtonSelect(2)
        self.setUpCoursesArray()
    }
    @IBAction func historyCourses(_ sender: Any) {
        self.subjectGroup = "History"
        self.subjectGroupButtonSelect(3)
        self.setUpCoursesArray()
    }
    @IBAction func spanishCourses(_ sender: Any) {
        self.subjectGroup = "Spanish"
        self.subjectGroupButtonSelect(4)
        self.setUpCoursesArray()
    }
    @IBAction func frenchCourses(_ sender: Any) {
        self.subjectGroup = "French"
        self.subjectGroupButtonSelect(5)
        self.setUpCoursesArray()
    }
    @IBAction func italianCourses(_ sender: Any) {
        self.subjectGroup = "Italian"
        self.subjectGroupButtonSelect(6)
        self.setUpCoursesArray()
    }
    @IBAction func germanCourses(_ sender: Any) {
        self.subjectGroup = "German"
        self.subjectGroupButtonSelect(7)
        self.setUpCoursesArray()
    }
    @IBAction func japaneseCourses(_ sender: Any) {
        self.subjectGroup = "Japanese"
        self.subjectGroupButtonSelect(8)
        self.setUpCoursesArray()
    }
    @IBAction func chineseCourses(_ sender: Any) {
        self.subjectGroup = "Chinese"
        self.subjectGroupButtonSelect(9)
        self.setUpCoursesArray()
    }
    @IBAction func latinCourses(_ sender: Any) {
        self.subjectGroup = "Latin"
        self.subjectGroupButtonSelect(10)
        self.setUpCoursesArray()
    }
    @IBAction func electiveCourses(_ sender: Any) {
        self.subjectGroup = "Elective"
        self.subjectGroupButtonSelect(11)
        self.setUpCoursesArray()
    }
    
    func subjectGroupButtonSelect(_ buttonIndex: Int) {
        //return all other buttons to normal
        
        subjectGroupButtons[buttonIndex].backgroundColor = Constants.Colors.studycloudredUI
        subjectGroupButtons[buttonIndex].isEnabled = false
        
        for button in self.subjectGroupButtons {
            if button == self.subjectGroupButtons[buttonIndex] {
                continue
            }
            button.backgroundColor = Constants.Colors.studycloudblueUI
            button.isEnabled = true
        }
    }
    
}
