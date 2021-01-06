//
//  ChooseCoursesViewController.swift
//  TutorHub
//
//  Created by Yash Mathur on 3/24/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class SelectCoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpCoursesArray()
        
        print("View has loaded :)")
    }
    
    //references
    @IBOutlet weak var saveButtonRef: UIButton!
    @IBOutlet var subjectGroupButtons: [UIButton]!
    
    //function to set up the elements
    func setUpElements() {
        
        //save button
        saveButtonRef.layer.cornerRadius = 15
        
        //table view
        self.addCoursesTableView.backgroundColor = UIColor.clear
        self.addCoursesTableView.allowsMultipleSelection = true
        
        //subject scroll bar
        for button in subjectGroupButtons {
            button.layer.cornerRadius = 10
            button.setTitleColor(.white, for: .disabled)
            button.setTitleColor(.black, for: .normal)
        }
        
        //disabling math button first
        subjectGroupButtons[0].backgroundColor = Constants.Colors.studycloudredUI
        subjectGroupButtons[0].isEnabled = false
    }
    
    //array for the data
    var coursesArray: [String] = []
    //variable to show which subject group is currently selected
    var subjectGroup = "Math"
    //setting up the courses Array
    func setUpCoursesArray() {
        switch subjectGroup {
        case "Math":
            self.coursesArray = Courses.mathCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "LAL":
            self.coursesArray = Courses.lalCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "Science":
            self.coursesArray = Courses.scienceCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "History":
            self.coursesArray = Courses.historyCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "Spanish":
            self.coursesArray = Courses.spanishCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "French":
            self.coursesArray = Courses.frenchCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "Italian":
            self.coursesArray = Courses.italianCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "German":
            self.coursesArray = Courses.germanCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "Japanese":
            self.coursesArray = Courses.japaneseCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "Chinese":
            self.coursesArray = Courses.chineseCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "Latin":
            self.coursesArray = Courses.latinCoursesArray
            self.addCoursesTableView.reloadData()
            break
        case "Elective":
            self.coursesArray = Courses.electiveCoursesArray
            self.addCoursesTableView.reloadData()
            break
        default:
            self.coursesArray = Courses.fullCoursesArray
            self.addCoursesTableView.reloadData()
        }
    }
    
    //subject grouping buttons
    @IBAction func mathCourses(_ sender: Any) {
        self.subjectGroup = "Math"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(0)
    }
    @IBAction func lalCourses(_ sender: Any) {
        self.subjectGroup = "LAL"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(1)
    }
    @IBAction func scienceCourses(_ sender: Any) {
        self.subjectGroup = "Science"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(2)
    }
    @IBAction func historyCourses(_ sender: Any) {
        self.subjectGroup = "History"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(3)
    }
    @IBAction func spanishCourses(_ sender: Any) {
        self.subjectGroup = "Spanish"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(4)
    }
    @IBAction func frenchCourses(_ sender: Any) {
        self.subjectGroup = "French"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(5)
    }
    @IBAction func italianCourses(_ sender: Any) {
        self.subjectGroup = "Italian"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(6)
    }
    @IBAction func germanCourses(_ sender: Any) {
        self.subjectGroup = "German"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(7)
    }
    @IBAction func japaneseCourses(_ sender: Any) {
        self.subjectGroup = "Japanese"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(8)
    }
    @IBAction func chineseCourses(_ sender: Any) {
        self.subjectGroup = "Chinese"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(9)
    }
    @IBAction func latinCourses(_ sender: Any) {
        self.subjectGroup = "Latin"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(10)
    }
    @IBAction func electiveCourses(_ sender: Any) {
        self.subjectGroup = "Elective"
        self.setUpCoursesArray()
        subjectGroupButtonSelect(11)
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
    
    
    //selected courses:
    var selectedCourses: [Int] = []

    //referneces to table
    @IBOutlet weak var addCoursesTableView: UITableView!
    
    //func to the teacher selection screen after making the selection
    func transitionToProfile() {
        let teachersVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.profileViewController) as?  ProfileViewController
        self.view.window?.rootViewController = teachersVC
        self.view.window?.makeKeyAndVisible()
    }
    
    // necessary table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell")
        cell?.textLabel?.text = coursesArray[indexPath.row]
        
        //maintaining selected courses
        for i in self.selectedCourses {
            let course = Courses.fullCoursesArray[i]
            let courseIndex: Int? = self.coursesArray.firstIndex(of: course)
            if let courseIndex = courseIndex {
                let path = IndexPath(row: courseIndex, section: 0)
                tableView.selectRow(at: path, animated: true, scrollPosition: .none)
            }
        }
        
        return cell!
    }
    
    //coding the table cells
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell")
        cell?.selectionStyle = .gray
        
        if self.subjectGroup == "Elective" {
            let course = coursesArray[indexPath.row]
            let data: Int? = Courses.fullCoursesArray.firstIndex(of: course)
            if let data = data {
                selectedCourses.append(data)
            }
        } else {
            for i in 0...indexPath.row {
                //selecting all the courses before
                let path = IndexPath(row: i, section: 0)
                tableView.selectRow(at: path, animated: true, scrollPosition: .none)
                let course = coursesArray[i]
                let data: Int? = Courses.fullCoursesArray.firstIndex(of: course)
                if let data = data {
                    if selectedCourses.contains(data) {
                        print("Course already added!")
                    } else {
                        selectedCourses.append(data)
                    }
                }
            }
            print(self.selectedCourses)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell")
        cell?.selectionStyle = .gray
        let course = coursesArray[indexPath.row]
        let data: Int? = Courses.fullCoursesArray.firstIndex(of: course)
        if let data = data {
            selectedCourses.remove(at: selectedCourses.firstIndex(of: data)!)
        }
    }
    
    //save selection button coding
    @IBAction func saveCoursesSelectionButton(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user{
            let uid: String = user.uid
            let db = Firestore.firestore()
            db.collection("Users").document(uid).updateData(["Courses" : selectedCourses]) { (error) in
                if let error = error{
                    print("There was an error \(error.localizedDescription)")
                } else {
                    print(self.selectedCourses)
                    self.transitionToProfile()
                }
            }
        } else {
            print("Hopefully this error never prints")
        }
    }

    
}

  
