//
//  NotificationCenterViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 10/8/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class NotificationCenterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        setUpArrays()
        
        print("View has loaded :)")
    }
    
    //passable uid
    var passableUID: String = ""
    
    //references
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var notifTableView: UITableView!
    
    //function to set up elemetns
    func setUpElements() {
        //nav bar
        navBar.layer.borderWidth = 3
        navBar.layer.borderColor = Constants.Colors.studycloudblueCG
    } //Set Up Elements
    
    //getting the list of notifications
    var uidArray: [String] = []
    var namesArray: [String] = []
    var numbersArray: [String] = []
    var emailsArray: [String] = []
    var subjectsArray: [String] = []
    var timestampsArray: [String] = []
    var notifTypeArray: [Bool] = []
    var documentReferences: [DocumentReference] = []
    
    func setUpArrays() {
        
        uidArray.removeAll()
        namesArray.removeAll()
        numbersArray.removeAll()
        emailsArray.removeAll()
        subjectsArray.removeAll()
        timestampsArray.removeAll()
        notifTypeArray.removeAll()
        documentReferences.removeAll()
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            db.collection("Users").document(uid).collection("Notifs").order(by: "Created", descending: true).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        let notifType: Bool = document.get("Req") as! Bool
                        let uid: String = document.get("From") as! String
                        let name: String = document.get("Name") as! String
                        let subject: String = document.get("Subject") as! String
                        let created: Timestamp = document.get("Created") as! Timestamp
                        let date = created.dateValue()
                        let today = Date()
                        let formatter = DateFormatter()
                        if date < today.addingTimeInterval(-43200) {
                            formatter.dateStyle = .short
                        } else {
                            formatter.timeStyle = .short
                        }
                        let timestamp: String = formatter.string(from: date)
                        let docRef: DocumentReference = document.reference
                        if notifType {
                            //request notif
                            self.numbersArray.append("Space")
                            self.emailsArray.append("Space")
                            
                        } else {
                            //update notif
                            let number: String? = document.get("#") as? String
                            let email: String = document.get("email") as! String
                            
                            self.numbersArray.append(number ?? "")
                            self.emailsArray.append(email)
                            
                        } //if-else
                        
                        self.uidArray.append(uid)
                        self.namesArray.append(name)
                        self.subjectsArray.append(subject)
                        self.timestampsArray.append(timestamp)
                        self.notifTypeArray.append(notifType)
                        self.documentReferences.append(docRef)
                        
                    } //for-in
                    self.notifTableView.reloadData()
                } //if-else
            } //Get Documents
        } //if
    } //Set Up Arrays
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uidArray.count
    } //Table View
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notifTypeArray[indexPath.row] {
            //request type
            let cell: RequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "requestNotif") as! RequestTableViewCell
            cell.titleLabel.text = "\(namesArray[indexPath.row]) has requested for help with \(subjectsArray[indexPath.row]). Tap to accept!"
            cell.timestampLabel.text = timestampsArray[indexPath.row]
            return cell
        } else {
            //update type
            let cell: UpdateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "updateNotif") as! UpdateTableViewCell
            cell.titleLabel.text = "\(namesArray[indexPath.row]) accepted your request for \(subjectsArray[indexPath.row]). Please contact them using the information below."
            cell.descriptionLabel.text = "Phone Number: \(numbersArray[indexPath.row]) \nEmail: \(emailsArray[indexPath.row])"
            cell.timestampLabel.text = timestampsArray[indexPath.row]
            return cell
        }
    } //Table View
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if (!notifTypeArray[indexPath.row]) {
            return false
        } else {
            return true
        } //if-else
    } //Table View
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notifTypeArray[indexPath.row] {
            //request type
            let acceptedUID = uidArray[indexPath.row]
            let acceptedSubject = subjectsArray[indexPath.row]
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let name: String? = user.displayName
                let number: String? = UserDefaults.standard.string(forKey: "Number")
                let email: String? = user.email
                let db = Firestore.firestore()
                if let name = name, let email = email {
                    let data = ["From" : uid, "Created" : Timestamp(), "Subject" : acceptedSubject, "Name" : name, "#" : number ?? "", "email" : email, "Req" : false] as [String : Any]
                    db.collection("Users").document(acceptedUID).collection("Notifs").document().setData(data)
                    
                    documentReferences[indexPath.row].delete { (error) in
                        if let error = error {
                            print("There was an error: \(error.localizedDescription)")
                        } else {
                            self.setUpArrays()
                            self.notifTableView.reloadData()
                        } //if-else
                    }
                } else {
                    print("Error accepting request")
                } //if-else
            } //if
        } else {
            //update type
            return
        }
    } //Table View

}
