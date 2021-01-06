//
//  SupportedCoursesViewController.swift
//  Study Hall
//
//  Created by Yash Mathur on 5/21/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class ProgramOfStudiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpCoursesArray()
        
        print("View has loaded :)")
    }
    
    //references
    @IBOutlet var subjectGroupButtons: [UIButton]!
    @IBOutlet weak var supportedCoursesTableView: UITableView!
    
    //function to set up the elements
    func setUpElements() {
        
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
        self.supportedCoursesTableView.backgroundColor = UIColor.clear
        self.supportedCoursesTableView.allowsSelection = false
    }
    
    //array for the data
    var coursesArray: [String] = []
    //variable to check selected subject group
    var subjectGroup = "Math"
    func setUpCoursesArray() {
        switch subjectGroup {
        case "Math":
            self.coursesArray = Courses.mathCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "LAL":
            self.coursesArray = Courses.lalCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "Science":
            self.coursesArray = Courses.scienceCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "History":
            self.coursesArray = Courses.historyCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "Spanish":
            self.coursesArray = Courses.spanishCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "French":
            self.coursesArray = Courses.frenchCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "Italian":
            self.coursesArray = Courses.italianCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "German":
            self.coursesArray = Courses.germanCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "Japanese":
            self.coursesArray = Courses.japaneseCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "Chinese":
            self.coursesArray = Courses.chineseCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "Latin":
            self.coursesArray = Courses.latinCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        case "Elective":
            self.coursesArray = Courses.electiveCoursesArray
            self.supportedCoursesTableView.reloadData()
            break
        default:
            self.coursesArray = Courses.fullCoursesArray
            self.supportedCoursesTableView.reloadData()
        }
    }
    
    //subject grouping buttons
    @IBAction func mathCourses(_ sender: Any) {
        self.subjectGroup = "Math"
        self.subjectGroupButtonSelect(0)
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
    
    //necessary table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "supportedCoursesCell")
        cell?.textLabel?.text = self.coursesArray[indexPath.row]
        return cell!
    }
    
}
