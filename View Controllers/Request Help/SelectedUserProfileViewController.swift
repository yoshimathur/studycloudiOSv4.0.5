//
//  SelectedUserProfileViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 7/9/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class SelectedUserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View has loaded :)")
        print(uid ?? "none")
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    //selected user uid
    var uid: String? = ""
    var subject: String? = ""
    
    //references
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var coursesTableView: UITableView!
    @IBOutlet weak var reportUserButtonRef: UIButton!
    @IBOutlet weak var requestHelpButtonRef: UIButton!
    
    //display array
    var coursesArray: [String] = []
    
    func setUpElements() {
        
        //layout
        errorLabel.alpha = 0
        reportUserButtonRef.layer.cornerRadius = 10
        requestHelpButtonRef.layer.cornerRadius = 10
        
        //displaying user data
        if let uid = self.uid {
            let db = Firestore.firestore()
            db.collection("Users").document(uid).getDocument { (document, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    let name = document?.get("Name") as? String
                    let grade = document?.get("Grade") as? String
                    let schoolCode = document?.get("School") as? String
                    var school: String? = ""
                    if let code = schoolCode {
                        school = SchoolsData.schoolsByCodesDic[code]
                    }
                    let courses: [Int]? = document?.get("Courses") as? [Int]
                    if let courses = courses {
                        for i in courses {
                            let course: String = Courses.fullCoursesArray[i]
                            self.coursesArray.append(course)
                            self.coursesArray.sort()
                            self.coursesTableView.reloadData()
                        }
                    }
                    self.nameLabel.text = name ?? "No Data!"
                    self.gradeLabel.text = "Grade: " + (grade ?? "No Data!")
                    self.schoolLabel.text = "School: " + (school ?? "No Data!")
                } //if else
            } //Get Documents
        } //if
        
        //table view
        coursesTableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesArray.count
    } //Table View
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classTeachPreviewCell")
        cell?.textLabel?.text = coursesArray[indexPath.row]
        return cell!
    } //Table View
    
    @IBAction func reportUser(_ sender: Any) {
        self.sendEmail(subject: "Report ID: \(self.uid ?? "Error")", content: "Write a detailed description of why you are reporting this user here. DO NOT CHANGE THE SUBJECT OF THE EMAIL!")
    } //Report User Button Action
    
    @IBAction func requestHelp(_ sender: Any) {
        if let uid = self.uid {
            let currentUser = Auth.auth().currentUser
            let sentBy = currentUser?.uid
            let name: String? = currentUser?.displayName
            let subject: String? = self.subject
            if let sentBy = sentBy, let name = name, subject != "" {
                let db = Firestore.firestore()
                let data = ["From" : sentBy, "Created" : Timestamp(), "Req" : true, "Name" : name, "Subject" : subject!] as [String : Any]
                db.collection("Users").document(uid).collection("Notifs").document().setData(data) { (error) in
                    if error != nil {
                        self.errorLabel.text = "There was an error trying to request help."
                        self.errorLabel.alpha = 1
                    } else {
                        self.errorLabel.text = "Your request was successfully sent!"
                        self.errorLabel.alpha = 1
                        self.requestHelpButtonRef.isEnabled = false
                    }
                }
                
            } else {
                self.errorLabel.text = "There was an error trying to request help"
                self.errorLabel.alpha = 1
                return
            } //if-else
        } //if
    } //Request Help
    
    //email functions
    func sendEmail(subject: String, content: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["hills.studycloud@gmail.com"])
            mail.setSubject(subject)
            mail.setMessageBody("<p>\(content)</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    } //Send Email

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    } //Mail Compose Controller
    

}
