//
//  MessagingHomeViewController.swiftMessagingHomeTableViewCell
//  Study Cloud
//
//  Created by Yash Mathur on 6/30/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class MessagingHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View has loaded :)")
        displayNotificationIcon()
        settingUpArrayOfPeopleYouHaveAChatWith()
        self.messagingHomeTableView.rowHeight = 75
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.chatListener?.remove()
        self.notifListener?.remove()
    }
    
    //references
    @IBOutlet weak var messagingHomeTableView: UITableView!
    
    //variables for selected user
    var selectedUserUID: String? = ""
    var selectedUserName: String? = ""
    var currentUserName: String? = ""
    
    //notification dictionary declaring whether a chat needs a notifaction or not
    var notificationDictionary: [String: Bool] = [:]
    //notification listener
    var notifListener: ListenerRegistration?
    //setting up the notification display
    func displayNotificationIcon() {
        let db = Firestore.firestore()
        db.collection("Chats").whereField("users", arrayContains: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let chat = Chat(dictionary: document.data())
                    let users: [String] = chat!.users
                    self.notifListener = document.reference.collection("thread").order(by: "created", descending: true).limit(to: 1).addSnapshotListener(includeMetadataChanges: true, listener: { (chatSnap, error) in
                        if let error = error {
                            print("There was an errror: \(error.localizedDescription)")
                        } else {
                            for lastMessage in chatSnap!.documents {
                                let lastMessageSender: String = lastMessage.get("senderID") as! String
                                let wasLastMsgSeen: Bool = lastMessage.get("read") as! Bool
                                if lastMessageSender != Auth.auth().currentUser?.uid && wasLastMsgSeen == false {
                                    print("Notification")
                                    for user in users {
                                        if user != Auth.auth().currentUser!.uid {
                                            self.notificationDictionary[user] = true
                                        }
                                    }
                                } else {
                                    for user in users {
                                        if user != Auth.auth().currentUser!.uid {
                                            self.notificationDictionary[user] = false
                                        }
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    //array of people you have a chat with
    var arrayOfPeopleYouHaveAChatWith: [String] = []
    var filteredPeoples: [String] = []
    //dictionary to display the timestamp with the chat description
    var dictionary: [Date: String] = [:]
    //array of the timestamps for the last message of each chat
    var timestampsArray: [String] = []
    var filteredTimestamps: [String] = []
    //array of the uids
    var uidArray: [String] = []
    var filtereduids: [String] = []
    //dictionary to sort the uids
    var uidDictionary: [Date: String] = [:]
    //last messages array
    var lastMsgArray: [String] = []
    var filteredMsgs: [String] = []
    //dictionary to sort the last messages
    var lastMsgDictionary: [Date: String] = [:]
    //chatlistener
    var chatListener: ListenerRegistration?
    
    //getting the users you have a chat with
    func settingUpArrayOfPeopleYouHaveAChatWith() {
        let user = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("Chats")
            .whereField("users", arrayContains: user.uid)
            .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let chats: [String] = document.get("users") as! [String]
                    self.chatListener = document.reference.collection("thread").order(by: "created", descending: true).limit(to: 1).addSnapshotListener(includeMetadataChanges: true, listener: { (chatSnap, error) in
                        if let error = error {
                            print("There was an errror: \(error.localizedDescription)")
                        } else {
                            for lastMessage in chatSnap!.documents {
                                let timestamp: Timestamp = lastMessage.get("created") as! Timestamp
                                let lastMessageContent: String = lastMessage.get("content") as! String
                                let date = timestamp.dateValue()
                                self.lastMsgDictionary[date] = lastMessageContent
                                //setting up the content of the cell
                                let currentUserUid = Auth.auth().currentUser?.uid
                                for element in chats {
                                    if element != currentUserUid! {
                                        let user2uid: String = element
                                        db.collection("Users").document(user2uid).getDocument { (document, error) in
                                            if let error = error {
                                                print("There was an error: \(error.localizedDescription)")
                                            } else {
                                                let userName: String = document!.get("Name") as! String
                                                let uid: String = document!.documentID
                                                self.dictionary[date] = userName
                                                self.uidDictionary[date] = uid
                                                //sorting the chat description elements
                                                self.arrayOfPeopleYouHaveAChatWith.removeAll()
                                                self.timestampsArray.removeAll()
                                                self.uidArray.removeAll()
                                                self.lastMsgArray.removeAll()
                                                let sortedPeople = Array(self.dictionary.keys.sorted()).reversed()
                                                for key in sortedPeople {
                                                    self.arrayOfPeopleYouHaveAChatWith.append(self.dictionary[key]!)
                                                    self.uidArray.append(self.uidDictionary[key]!)
                                                    self.lastMsgArray.append(self.lastMsgDictionary[key]!)
                                                    
                                                    //adding the timestamp
                                                    let today = Date()
                                                    let formatter = DateFormatter()
                                                    if key < today.addingTimeInterval(-43200) {
                                                        formatter.dateStyle = .short
                                                        } else {
                                                        formatter.timeStyle = .short
                                                    }
                                                    
                                                    let lastMessageTimestamp: String = formatter.string(from: key)
                                                    self.timestampsArray.append(lastMessageTimestamp)
                                                }
                                                self.filtereduids = self.uidArray.removingDuplicates()
                                                self.filteredPeoples.removeAll()
                                                self.filteredMsgs.removeAll()
                                                self.filteredTimestamps.removeAll()
                                                for uid in self.filtereduids {
                                                    let today = Date()
                                                    let formatter = DateFormatter()
                                                    let keys = self.uidDictionary.allKeys(forValue: uid)
                                                    let sortedkeys = Array(keys.sorted().reversed())
                                                    let key = sortedkeys[0]
                                                    if key < today.addingTimeInterval(-43200) {
                                                        formatter.dateStyle = .short
                                                    } else {
                                                        formatter.timeStyle = .short
                                                    }
                                                    self.filteredMsgs.append(self.lastMsgDictionary[key]!)
                                                    self.filteredPeoples.append(self.dictionary[key]!)

                                                    let lastMessageTimestamp: String = formatter.string(from: key)
                                                    self.filteredTimestamps.append(lastMessageTimestamp)
                                                }
                                                self.messagingHomeTableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    //necessary table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtereduids.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //setting up basic chat description
        let cell: MessagingHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "messagingHomeCell") as! MessagingHomeTableViewCell
        cell.nameLabel.text = filteredPeoples[indexPath.row]
        cell.lastMessageLabel.text = filteredMsgs[indexPath.row]
        cell.timestampLabel.text = filteredTimestamps[indexPath.row]
        cell.uidLabel.text = filtereduids[indexPath.row]
        cell.nameLabel.numberOfLines = 0
        cell.lastMessageLabel.numberOfLines = 0
        cell.uidLabel.alpha = 0
        cell.profileImage.layer.cornerRadius = 25
        
        let notification: Bool = self.notificationDictionary[cell.uidLabel.text!]!
        if notification == true {
            cell.accessoryType = .none
            cell.accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            cell.accessoryView?.backgroundColor = UIColor.init(named: "Study Cloud Button Color ")
            cell.accessoryView?.layer.cornerRadius = 5
        }
        
        return cell
        
    }
    
    //function for clicking on the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let db = Firestore.firestore()
        let cell: MessagingHomeTableViewCell = messagingHomeTableView.dequeueReusableCell(withIdentifier: "messagingHomeCell") as! MessagingHomeTableViewCell
        cell.uidLabel.text = uidArray[indexPath.row]
        cell.nameLabel.text = arrayOfPeopleYouHaveAChatWith[indexPath.row]
        self.selectedUserName = cell.nameLabel.text!
        self.selectedUserUID = cell.uidLabel.text!
        
        //getting currentUserName
        db.collection("Users").document(Auth.auth().currentUser!.uid).getDocument { (doc, error) in
            if let error = error {
                print("There was an error \(error.localizedDescription)")
            } else {
                self.currentUserName = doc!.get("Name") as? String
                self.performSegue(withIdentifier: "MessagingHomeToChat", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reportAction = UIContextualAction(style: .normal, title: "Report") { (action, view, handler) in
            let uid = self.filtereduids[indexPath.row]
            self.sendEmail(subject: "Report ID: \(uid)", content: "Write a detailed description of why you are reporting this user here. DO NOT CHANGE THE SUBJECT OF THE EMAIL!")
        }
        
        reportAction.backgroundColor = Constants.Colors.studycloudredUI
        let swipe = UISwipeActionsConfiguration(actions: [reportAction])
        return swipe
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessagingHomeToChat" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.user2Name = self.selectedUserName!
            chatVC.user2UID = self.selectedUserUID
            chatVC.currentUserName = self.currentUserName!
        }
    }
    
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
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

//extenstion for deleting repeats in an array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
