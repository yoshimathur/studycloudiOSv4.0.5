//
//  ChatViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 7/4/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import FirebaseFirestore
import FirebaseMessaging

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checking if data came over
        print(self.user2Name ?? "No Name")
        print(self.user2UID ?? "No UID")
        print(currentUserName)
        
        //adding methods to self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        //setting up elements
        setUpElements()
        
        //getting fcm token for the recepient
        getRecepientFCMToken()
        
        //reading texts
        readMessages()
        
        //loading the chat
        loadChat()
        
        print("View has loaded :)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.messageInputBar.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.listener?.remove()
        self.messageInputBar.alpha = 0
    }
    
    //delete pop up references
   
    //Colors
    let blue: UIColor = Constants.Colors.studycloudblueUI
    let user2Color = UIColor.init(named: "Study Cloud Solid BG")
    
    //references
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var deleteChatPopUp: UIView!
    @IBOutlet weak var deleteChatPopUpLabel: UILabel!
    @IBOutlet weak var cancelDeleteButtonRef: UIButton!
    @IBOutlet weak var deleteChatButtonRef: UIButton!
    
    //function to set up other chat elements
    func setUpElements() {
        
        //Message color
        
        
        //activating input bar
        self.title = user2Name ?? "Chat"
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .lightGray
        messageInputBar.sendButton.setTitleColor(blue, for: .normal)
        
        //constraining
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        view.addSubview(messagesCollectionView)
        view.removeConstraint(view.constraints[6])
        view.addConstraint(NSLayoutConstraint(item: header!, attribute: .bottom, relatedBy: .equal, toItem: messagesCollectionView, attribute: .top, multiplier: 1, constant: 0))
        
        //writing the header label for the chat
        self.headerLabel.text = user2Name
        
        //delete chat pop up view
        deleteChatPopUp.alpha = 0
        deleteChatPopUp.layer.cornerRadius = 10
        deleteChatPopUp.layer.borderWidth = 3
        deleteChatPopUp.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        cancelDeleteButtonRef.layer.cornerRadius = 10
        cancelDeleteButtonRef.clipsToBounds = true
        cancelDeleteButtonRef.layer.maskedCorners = .layerMinXMaxYCorner
        deleteChatButtonRef.layer.cornerRadius = 10
        deleteChatButtonRef.clipsToBounds = true
        deleteChatButtonRef.layer.maskedCorners = .layerMaxXMaxYCorner
        deleteChatPopUp.layer.cornerRadius = 10
    }
    
    //push notifications
    var recepientFCMToken: String? = ""
    
    func getRecepientFCMToken() {
        if user2UID != nil {
            let db = Firestore.firestore()
            db.collection("Users").document(user2UID!).getDocument { (document, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    self.recepientFCMToken = document!.get("fcmToken") as? String
                    print(self.recepientFCMToken as Any)
                }
            }
        }
    }
    
    //user variables
    var currentUser: User = Auth.auth().currentUser!
    var currentUserName: String = ""
    
    var user2Name: String? = ""
    var user2UID: String? = ""
    
    //messaging varibales
    private var docReference: DocumentReference?
    var messages: [Message] = []
    
    //setting up date variable
    var timestampArray: [Int] = []
    var recentMessageTimestamp: Int = 0
    var previousMessageTimestamp: Int = 0
    var display: CGFloat = 0
    
    //attributes for string
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.init(named: "Study Cloud Chat User2 Text")!
    ]
    
    //listener
    var listener: ListenerRegistration?
    
    
    func readMessages() {
        let db = Firestore.firestore()
        db.collection("Chats").whereField("users", arrayContains: currentUser.uid).getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            } else {
                for chats in chatQuerySnap!.documents {
                    let chat = Chat(dictionary: chats.data())
                    if (chat?.users.contains(self.user2UID!))! {
                        
                        self.listener = chats.reference.collection("thread").order(by: "created", descending: true).limit(to: 1).addSnapshotListener(includeMetadataChanges: true, listener: { (lastmsgQuerrySnap, error) in
                            if let error = error {
                                print("There was an error: \(error.localizedDescription)")
                            } else {
                                for lastmsg in lastmsgQuerrySnap!.documents {
                                    let sender: String = lastmsg.get("senderID") as! String
                                    if sender != self.currentUser.uid {
                                        chats.reference.collection("thread")
                                            .whereField("read", isEqualTo: false)
                                            .whereField("senderID", isEqualTo: self.user2UID!)
                                            .getDocuments { (user2msgsQuerySnap, error) in
                                            if let error = error {
                                                print("There was an error: \(error.localizedDescription)")
                                            } else {
                                                for msgs in user2msgsQuerySnap!.documents {
                                                    let msgsuid = msgs.documentID
                                                    db.collection("Chats").document(chats.documentID).collection("thread").document(msgsuid).updateData(["read" : true]) { (error) in
                                                        if let error = error {
                                                            print("There was an error: \(error.localizedDescription)")
                                                        } else {
                                                            return
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        })
                        return
                    }
                }
            }
        }
    }

    
    func createNewChat() {
        let users = [self.currentUser.uid, self.user2UID]
        let data: [String: Any] = ["users": users]
        let db = Firestore.firestore()
        db.collection("Chats").addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create new chat: \(error.localizedDescription)")
                return
            } else {
                self.loadChat()
            }
        }
    }
    
    func loadChat() {
        
        //Fetching all the chats with the curent user in it
        let db = Firestore.firestore()
        db.collection("Chats").whereField("users", arrayContains: currentUser.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            } else {
                //count the number of documents tht are returned
                guard let queryCount = querySnapshot?.documents.count else {
                    return
                }
                
                if queryCount == 0 {
                    //user has no chat availabale and a new chat needs to be created
                    self.createNewChat()
                    
                } else if queryCount >= 1 {
                    
                    //Chats exist for the current user
                    for doc in querySnapshot!.documents {
                        let chat = Chat(dictionary: doc.data())
                        
                        //get the chat with the selected user 2 in it
                        if(chat?.users.contains(self.user2UID!))! {
                            self.docReference = doc.reference
                            
                            //fetch the thread collection
                            doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true) { (threadQuerry, error) in
                                if let error = error {
                                    print("There was an error: \(error.localizedDescription)")
                                    return
                                } else {
                                    self.messages.removeAll()
                                    for message in threadQuerry!.documents {
                                        let msg = Message(dictionary: message.data())
                                        self.messages.append(msg!)
                                }
                                    self.messagesCollectionView.reloadData()
                                    self.messagesCollectionView.scrollToBottom(animated: true)
                                }
                            }
                            return
                        }
                    }
                    self.createNewChat()
                } else {
                    print("You screwed up buddy")
                }
            }
        }
    }
    
    //two functions in order to insert a new message into the feed and a second to save the message into firestore
    private func insertNewMessage(_ message: Message) {
        
        //add the message to the messsages array and then simply reload it
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    private func save(_ message: Message) {
        
        //preparing data to be saved into firestore
        let data: [String: Any] = ["content": message.content, "created": message.created, "id": message.id, "senderID": message.senderID, "senderName": message.senderName, "read": false]
        docReference?.collection("thread").addDocument(data: data) { (error) in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    //InputBarAccessoryViewDelegate method
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        //method called when the user presses the send button
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: self.currentUser.uid, senderName: self.currentUserName)
        self.insertNewMessage(message)
        self.save(message)
        
        //clearing the input field
        inputBar.inputTextView.text = ""
        
        //reload data
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    
    //MessagesDataSource methods
    
    //return the current senderID and name
    func currentSender() -> SenderType {
        return Sender(senderId: self.currentUser.uid, displayName: self.currentUserName)
    }
    
    //return the MessageType
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    //return total number of messages
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            print("There are no messages")
            return 0
        } else {
            return messages.count
        }
    }
    
    //MessagesLayoutDelegate methods
    
    //avatar size
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    //MessagesDisplayDelegate methods
    
    //Background colors of the bubbles
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? blue: user2Color!
    }
    
    //avatar image
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == currentUser.uid {
            let initial = currentUserName[0]
            avatarView.initials = initial
            avatarView.placeholderTextColor = .white
            avatarView.backgroundColor = self.blue
        } else {
            let initial = user2Name![0]
            avatarView.initials = initial
            avatarView.placeholderTextColor = .label
            avatarView.backgroundColor = self.user2Color!
        }
    }
    
    //giving the bubbles some tails
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    //timestamping the messages as needed
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sentDate: Date = message.sentDate
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let timestamp: String = formatter.string(from: sentDate)
        return NSAttributedString(string: timestamp, attributes: self.attributes)
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        let timestamp: Int = Int(message.sentDate.timeIntervalSince1970)
        self.timestampArray.append(timestamp)
        if timestampArray.count == 0 {
            recentMessageTimestamp = 0
            previousMessageTimestamp = 0
        } else if timestampArray.count == 1 {
            recentMessageTimestamp = timestampArray.last!
            previousMessageTimestamp = 0
        } else if timestampArray.count > 1 {
            let arraySlice: [Int] = timestampArray.suffix(2)
            recentMessageTimestamp = arraySlice[1]
            previousMessageTimestamp = arraySlice[0]
        }
        let interval = recentMessageTimestamp - previousMessageTimestamp
        if interval > 3600 {
           display = 30
        } else {
            display = 0
        }
        return display
    }
    
    
    
    //need to make inputbar disapear after transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatToMessagingHome" {
            messageInputBar.isHidden = true
        } else if segue.identifier == "chatInfoToSelectedUserProfile" {
            let profileVC = segue.destination as! SelectedUserProfileViewController
            profileVC.uid = self.user2UID
        }
    }
    
    //deleting the chat
    @IBAction func deleteChat(_ sender: Any) {
        print("Delete Pop Up")
        view.bringSubviewToFront(deleteChatPopUp)
        self.deleteChatPopUp.alpha = 1
    }
    @IBAction func cancelDelete(_ sender: Any) {
        self.deleteChatPopUp.alpha = 0
    }
    @IBAction func confirmDeleteChat(_ sender: Any) {
        self.listener?.remove()
        //finding the chat in the database
        let userUID = self.currentUser.uid
        if let user2UID = self.user2UID {
            let db = Firestore.firestore()
            db.collection("Chats").whereField("users", in: [[userUID, user2UID], [user2UID, userUID]]).getDocuments { (query, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                    self.deleteChatPopUpLabel.text = "Error: " + error.localizedDescription + "Please contact support!"
                } else {
                    for document in query!.documents {
                        let id = document.documentID
                        //deleting the thread
                        db.collection("Chats").document(id).collection("thread").getDocuments { (thread, error) in
                            if let error = error {
                                print("There was an error: \(error.localizedDescription)")
                                self.deleteChatPopUpLabel.text = "Error: " + error.localizedDescription + "Please contact support!"
                            } else {
                                for documents in thread!.documents {
                                    let threadDoc = documents.documentID
                                    db.collection("Chats").document(id).collection("thread").document(threadDoc).delete()
                                }
                                print("Thread deleted")
                                //thread deleted
                                //deleting chat
                                db.collection("Chats").document(id).delete { (error) in
                                    if let error = error {
                                        print("There was an error: \(error.localizedDescription)")
                                        self.deleteChatPopUpLabel.text = "Error: " + error.localizedDescription + "Please contact support!"
                                    } else {
                                        let newVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.profileViewController) as? ProfileViewController
                                        self.view.window?.rootViewController = newVC
                                        self.view.window?.makeKeyAndVisible()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

//extension to call characters of a string by their index
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}






