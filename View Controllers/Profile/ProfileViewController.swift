//
//  ProfileViewController.swift
//  TutorHub
//
//  Created by Yash Mathur on 3/4/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        print("View has loaded :)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    //references
    @IBOutlet weak var settingsButtonRef: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelToDisplayNameOfUser: UILabel!
    @IBOutlet weak var labelToDisplaySchoolOfUser: UILabel!
    @IBOutlet weak var labelToDisplayGradeOfUser: UILabel!
    
    @IBOutlet weak var helperToggleSwitchRef: UISwitch!
    //settings stuff
    @IBOutlet weak var settingsMenu: UIView!
    @IBOutlet weak var settingsBorder: UIView!
    @IBOutlet weak var settings_addCourseButtonRef: UIButton!
    @IBOutlet weak var settings_programOfStudiesButtonRef: UIButton!
    //navBar
    @IBOutlet weak var navBar: UIView!
    //table views
    @IBOutlet weak var coursesTableView: UITableView!
    
    //variable arrays to display courses and teachers
    var coursesArray: [String] = ["Loading..."]
    var teachersArray: [String] = ["Loading..."]
    
    //function to set up elements
    func setUpElements() {
        
        //initial conditions before checking if user is not an underclassman
        self.helperToggleSwitchRef.isEnabled = false
        self.helperToggleSwitchRef.isOn = false
        self.coursesTableView.alpha = 0
        self.settings_addCourseButtonRef.isEnabled = false
        self.settings_programOfStudiesButtonRef.isEnabled = false
        
        //settings menu invisible at first
        settingsMenu.alpha = 0
        settingsBorder.alpha = 0
        
        //labels
        self.labelToDisplayNameOfUser.numberOfLines = 2
        self.labelToDisplayNameOfUser.alpha = 1
        self.labelToDisplaySchoolOfUser.numberOfLines = 0
        self.labelToDisplaySchoolOfUser.alpha = 1
        self.labelToDisplayGradeOfUser.numberOfLines = 0
        self.labelToDisplayGradeOfUser.alpha = 1
        
        //setting up the profile image
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = Constants.Colors.studycloudblueCG
        profileImage.layer.cornerRadius = 10
        
        //table view elements
        coursesTableView.allowsSelection = false
        coursesTableView.backgroundColor = UIColor.clear
        coursesTableView.layer.cornerRadius = 10
        coursesTableView.layer.borderWidth = 3.5
        coursesTableView.layer.borderColor = Constants.Colors.studycloudredCG
        
        //navBar elements
        navBar.layer.borderWidth = 3
        navBar.layer.borderColor = Constants.Colors.studycloudblueCG

        //setting up user information
        let personals: [Any]? = UserDefaults.standard.array(forKey: "Personals")
        if UserDefaults.standard.array(forKey: "Personals") != nil {
            print("Using user defaults")
            self.labelToDisplayNameOfUser.text = (personals![0] as! String)
            self.labelToDisplaySchoolOfUser.text = (personals![1] as! String)
            self.labelToDisplayGradeOfUser.text = (personals![3] as! String)
            if !UserDefaults.standard.bool(forKey: "Underclassman") {
                self.helperToggleSwitchRef.isEnabled = true
                self.coursesTableView.alpha = 1
                self.settings_addCourseButtonRef.isEnabled = true
                self.settings_programOfStudiesButtonRef.isEnabled = true
                self.coursesArray = UserDefaults.standard.array(forKey: "Courses") as! [String]
                self.setUpHelperSwitch()
            } else {
                return
            }
        } else {
            self.setUpUserInfo()
        }
        
    } //Set Up Elements
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCoursesCell")
        cell?.textLabel?.text = coursesArray[indexPath.row]
        cellToReturn = cell!
        return cellToReturn
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            //deleting the selected course from the database
            if tableView == self.coursesTableView {
                let deletedCourse: String = self.coursesArray[indexPath.row]
                let deletedCourseIndex: Int = Courses.fullCoursesArray.firstIndex(of: deletedCourse)!
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let db = Firestore.firestore()
                    db.collection("Users").document(uid).updateData(["Courses" : FieldValue.arrayRemove([deletedCourseIndex])])
                        
                    //refreshing the tableview
                    self.coursesArray.remove(at: self.coursesArray.firstIndex(of: deletedCourse)!)
                    UserDefaults.standard.setValue(self.coursesArray, forKey: "Courses")
                    self.coursesTableView.reloadData()
                }
            }
        }
        
        deleteAction.backgroundColor = Constants.Colors.studycloudredUI
        let delete = UISwipeActionsConfiguration(actions: [deleteAction])
        return delete
    }
    
    //setting up user information
    func setUpUserInfo() {
        //setting up user info
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            let docRef = db.collection("Users").document(uid)
            docRef.getDocument{ (document, error) in
                if let document = document {
                    //getting user name
                    let fullName: String? = user.displayName
                    self.labelToDisplayNameOfUser.text = fullName ?? "No Name"
                    
                    let number: String? = document.get("#") as? String
                    
                    let schoolCode: String? = document.get("School") as? String
                    var school: String? = nil
                    if let code = schoolCode {
                        school = SchoolsData.schoolsByCodesDic[code]
                    }
                    self.labelToDisplaySchoolOfUser.text = school ?? "No School"
                    
                    let district: Int? = document.get("District") as? Int
                    
                    let grade: String? = document.get("Grade") as? String
                    self.labelToDisplayGradeOfUser.text = grade ?? "No Grade"
                    
                    //creating a different style for underclassman
                    if let grade = grade {
                        
                        //student is an underclassman
                        if grade != "Underclassman" {
                            //student is in high school
                            
                            //saving data to defaults
                            UserDefaults.standard.setValue(false, forKey: "Underclassman")
                            let personals: [Any] = [fullName!, school!, district!, grade]
                            UserDefaults.standard.setValue(personals, forKey: "Personals")
                            UserDefaults.standard.setValue(number!, forKey: "Number")
                            
                            //enabling high school user buttons
                            self.helperToggleSwitchRef.isEnabled = true
                            self.coursesTableView.alpha = 1
                            self.settings_addCourseButtonRef.isEnabled = true
                            self.settings_programOfStudiesButtonRef.isEnabled = true
                            self.setUpHelperSwitch()
                            self.setUpArrays()
                        } else {
                            UserDefaults.standard.setValue(true, forKey: "Underclassman")
                            let personals: [Any] = [fullName!, school!, district!, grade]
                            UserDefaults.standard.setValue(personals, forKey: "Personals")
                        }
                    } else {
                        
                        //this handles if the user did not finish the sign up process
                        
                        //disabling buttons
                        self.helperToggleSwitchRef.isEnabled = false
                        self.coursesTableView.alpha = 0
                        self.settingsButtonRef.isEnabled = true
                        self.settings_addCourseButtonRef.isEnabled = false
                        self.settings_programOfStudiesButtonRef.isEnabled = false
                        
                        //deleting the unwanted-half-signed-up-user
                        let user = Auth.auth().currentUser
                        if let user = user {
                            let uid = user.uid
                            Firestore.firestore().collection("Users").document(uid).delete { (error) in
                                if let error = error {
                                    print("There was an error: \(error.localizedDescription)")
                                } else {
                                    //deleted the user
                                    user.delete(completion: { (error) in
                                        if let error = error {
                                            print("There was an error: \(error.localizedDescription)")
                                            
                                            let badSingUpViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.badSignUpViewController) as? BadSignUpViewController
                                            self.view.window?.rootViewController = badSingUpViewController
                                            self.view.window?.makeKeyAndVisible()
                                            
                                        } else {
                                            //account deleted
                                            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.homeViewController) as? HomeViewController
                                            self.view.window?.rootViewController = homeViewController
                                            self.view.window?.makeKeyAndVisible()
                                        }
                                    })
                                }
                            }
                        } else {
                            fatalError()
                        }
                    }

                    
                } else {
                    print ("Error finding user information: \(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            print("Error: You screwed up buddy!")
        }
    }
    
    //setting up the arrays
    func setUpArrays() {
        self.coursesArray.removeAll()
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            db.collection("Users").document(uid).getDocument { (document, error) in
                if let error = error{
                    print("There was an error: \(error.localizedDescription)")
                } else if document?.exists == true {
                    //courses
                    let courses = document?.get("Courses") as? [Int]
                    if let courses = courses {
                        for i in courses {
                            let course: String = Courses.fullCoursesArray[i]
                            self.coursesArray.append(course)
                        }
                    }
                    self.coursesArray.sort()
                    UserDefaults.standard.setValue(self.coursesArray, forKey: "Courses")
                    self.coursesTableView.reloadData()
                }
            }
        }
    }
    
    //toggle helper on and off
    @IBAction func helperToggle(_ sender: UISwitch) {
        if helperToggleSwitchRef.isOn {
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let db = Firestore.firestore()
                db.collection("Users").document(uid).setData(["Helper" : true], merge: true)
            }
        } else {
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let db = Firestore.firestore()
                db.collection("Users").document(uid).setData(["Helper" : false], merge: true)
            }
        }
    }
    
    //setting up the switch based on the value in the firestore database
    func setUpHelperSwitch() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            db.collection("Users").document(uid).getDocument { (document, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    if document!.exists {
                        let switchState: Bool? = document?.get("Helper") as? Bool
                        self.helperToggleSwitchRef.isOn = switchState ?? false
                    }
                }
            }
        }
    }
    
    //settings buttons
    @IBAction func settingsButton(_ sender: Any) {
        if settingsMenu.alpha == 0{
            settingsMenu.alpha = 1
            settingsBorder.alpha = 1
            view.bringSubviewToFront(settingsButtonRef)
            view.bringSubviewToFront(settingsMenu)
        } else {
            settingsMenu.alpha = 0
            settingsBorder.alpha = 0
            view.bringSubviewToFront(settingsButtonRef)
        }
        settingsMenu.layer.cornerRadius = 10
        settingsMenu.clipsToBounds = true
        settingsMenu.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        settingsBorder.layer.cornerRadius = 10
        settingsBorder.clipsToBounds = true
        settingsBorder.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    } //Settings Button Button Action
    
    @IBAction func settingsCancel(_ sender: Any) {
        settingsMenu.alpha = 0
        settingsBorder.alpha = 0
    } //Settings Cancel Button Action
    
    @IBAction func contactSupport(_ sender: Any) {
        self.sendEmail(subject: "Support", content: "What's up?")
    } //Contact Support Button Action
    
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
                print ("Error signing out!", signOutError)
        }
            
        //transition back to the home view controller
        UserDefaults.standard.removeObject(forKey: "Personals")
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.homeViewController) as? HomeViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    } //Log Out Button Action
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    //NOW UNUSED FUNCTIONS

    //not allowing to chat back during school - if implemented in libraries, there is no need for this function
//    func hideChatDuringSchool() {
//        let now = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateString = formatter.string(from: now)
//        let components = Calendar.current.dateComponents([.hour, .minute], from: now)
//        let hour = components.hour ?? 0
//        let db = Firestore.firestore()
//        let user = Auth.auth().currentUser
//        if let user = user {
//            let uid = user.uid
//            db.collection("Users").document(uid).getDocument { (document, error) in
//                if let error = error {
//                    print("There was an error: \(error.localizedDescription)")
//                } else {
//                    if let document = document {
//                        let school: String? = (document.get("School") as? [String])?.joined(separator: ", ")
//                        if let school = school {
//                            db.collection("Admins").document(school).getDocument { (adminDocument, error) in
//                                if let error = error {
//                                    print("There was an error: \(error.localizedDescription)")
//                                } else {
//                                    if let adminDocument = adminDocument {
//                                        let chatIsEnabled: Bool = adminDocument.get("Chat") as! Bool
//                                        let halfDays: [String] = adminDocument.get("Half Days") as! [String]
//                                        let holidays: [String] = adminDocument.get("Holidays") as! [String]
//                                        let hours: [Int] = adminDocument.get("Hours") as! [Int]
//                                        let halfHours: [Int] = adminDocument.get("HalfHours") as! [Int]
//                                        if chatIsEnabled == false {
//                                            self.chatButtonRef.isEnabled = false
//                                        } else if holidays.contains(dateString) {
//                                            self.chatButtonRef.isEnabled = true
//                                        } else if halfDays.contains(dateString) {
//                                            if hour >= halfHours[0] && hour < halfHours[1] && Calendar.current.isDateInWeekend(now) == false {
//                                                self.chatButtonRef.isEnabled = false
//                                            } else {
//                                                self.chatButtonRef.isEnabled = true
//                                            }
//                                        } else {
//                                            if hour >= (hours[0]) && hour < (hours[1]) && Calendar.current.isDateInWeekend(now) == false{
//                                                self.chatButtonRef.isEnabled = false
//                                            } else {
//                                                self.chatButtonRef.isEnabled = true
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        print(hour)
//    }
    
    //setting up the badge on the chat as notifactions
//    var notificationCount: [Bool] = []
//    var notifListener: ListenerRegistration?
//
//    func setUpNotificationsCount() {
//        let db = Firestore.firestore()
//        db.collection("Chats").whereField("users", arrayContains: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("There was an error: \(error.localizedDescription)")
//            } else {
//                for document in querySnapshot!.documents {
//                    self.notifListener = document.reference.collection("thread").order(by: "created", descending: true).limit(to: 1).addSnapshotListener(includeMetadataChanges: true, listener: { (chatSnap, error) in
//                        if let error = error {
//                            print("There was an errror: \(error.localizedDescription)")
//                        } else {
//                            self.notificationCount.removeAll()
//                            for lastMessage in chatSnap!.documents {
//                                let lastMessageSender: String = lastMessage.get("senderID") as! String
//                                let wasLastMsgSeen: Bool = lastMessage.get("read") as! Bool
//                                if lastMessageSender != Auth.auth().currentUser?.uid && wasLastMsgSeen == false {
//                                    print("Notification")
//                                    self.notificationCount.append(true)
//                                } else {
//                                    self.notificationCount.append(false)
//                                }
//                                let mappedItems = self.notificationCount.map {($0, 1)}
//                                let counts = Dictionary(mappedItems, uniquingKeysWith: +)
//                                if counts[false] == self.notificationCount.count {
//                                    return
//                                } else {
//                                    self.chatBadge.layer.cornerRadius = 5
//                                    self.chatBadge.layer.masksToBounds = true
//                                    self.chatBadge.alpha = 1
//                                    self.chatBadge.text = ""
//                                    UIApplication.shared.applicationIconBadgeNumber = 1
//                                }
//                            }
//                        }
//                    })
//                }
//            }
//        }
//    }
//
}
