//
//  SelectGradeViewController.swift
//  TutorHub
//
//  Created by Yash Mathur on 3/24/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class SelectGradeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        print("View has loaded :)")
    }
    
    //references
    @IBOutlet weak var underclassmanButtonRef: UIButton!
    @IBOutlet weak var freshmanButtonRef: UIButton!
    @IBOutlet weak var sophomoreButtonRef: UIButton!
    @IBOutlet weak var juniorButtonRef: UIButton!
    @IBOutlet weak var seniorButtonRef: UIButton!
    
    //function to set up the elements
    func setUpElements() {
        underclassmanButtonRef.layer.cornerRadius = 15
        freshmanButtonRef.layer.cornerRadius = 15
        sophomoreButtonRef.layer.cornerRadius = 15
        juniorButtonRef.layer.cornerRadius = 15
        seniorButtonRef.layer.cornerRadius = 15
    }
    
    
    //function to transition to the next page
    func transitionToSelectCourses() {
        let newVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.addCoursesViewController) as? SelectCoursesViewController
        self.view.window?.rootViewController = newVC
        self.view.window?.makeKeyAndVisible()
    }
    
    //funciton to transition to the profile page
    func transitionToProfile() {
        let newVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.profileViewController) as? ProfileViewController
        self.view.window?.rootViewController = newVC
        self.view.window?.makeKeyAndVisible()
    }
        
    //code the individual buttons to store user data

    @IBAction func underclassmanButton(_ sender: Any) {
        
        //saving the data
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            db.collection("Users").document(uid).updateData(["Grade" : "Underclassman", "Helper" : false])
        }
        
        //transition
        self.transitionToProfile()
    }
    
    @IBAction func freshmanButton(_ sender: Any) {
       
        //saving the data
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            let tag = Int.random(in: 1...100)
            db.collection("Users").document(uid).updateData(["Grade" : "Freshman", "Helper" : true, "Tag" : tag])
        }
        
        //transition
        self.transitionToSelectCourses()
    }
    
    @IBAction func sophmoreButton(_ sender: Any) {

        //saving the data
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            let tag = Int.random(in: 1...100)
            db.collection("Users").document(uid).updateData(["Grade" : "Sophomore", "Helper" : true, "Tag" : tag])
        }
        
        //transition
        self.transitionToSelectCourses()
    }
    
    @IBAction func juniorButton(_ sender: Any) {

        //saving the data
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            let tag = Int.random(in: 1...100)
            db.collection("Users").document(uid).updateData(["Grade" : "Junior", "Helper" : true, "Tag" : tag])
        }
        
        //transition
        self.transitionToSelectCourses()
    }
    
    @IBAction func seniorButton(_ sender: Any) {

        //saving the data
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            let tag = Int.random(in: 1...100)
            db.collection("Users").document(uid).updateData(["Grade" : "Senior", "Helper" : true, "Tag" : tag])
        }
        
        //transition
        self.transitionToSelectCourses()
    }
    
}
