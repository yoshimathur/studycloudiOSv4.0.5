//
//  InfoChangeReqViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 10/12/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class InfoChangeReqViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        print("View has loaded :)")
    }
    
    //references
    @IBOutlet weak var nameChangeTextView: UITextView!
    @IBOutlet weak var numberChangeTextView: UITextView!
    @IBOutlet weak var schoolChangeTextView: UITextView!
    @IBOutlet weak var credentialChangeTextView: UITextView!
    @IBOutlet weak var sendReqButtonRef: UIButton!
    
    //function to set up the elements
    func setUpElements() {
        
        //button
        sendReqButtonRef.layer.cornerRadius = 10
        
    }
    
    @IBAction func sendReq(_ sender: Any) {
        if nameChangeTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" && numberChangeTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" && schoolChangeTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" && credentialChangeTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            print("Error")
            return
        } else {
            var uid: String = ""
            let user = Auth.auth().currentUser
            if let user = user {
                uid = user.uid
                let nameChange = "Name Change: " + (nameChangeTextView.text ?? "None")
                let numberChange = "Number Change: " + (numberChangeTextView.text ?? "None")
                let schoolChange = "School / Grade Change: " + (schoolChangeTextView.text ?? "None")
                let credentialChange = "Credential Change: " + (credentialChangeTextView.text ?? "None")
                self.sendEmail(subject: "Information Change", nameChange: nameChange, numberChange: numberChange, schoolChange: schoolChange, credentialChange: credentialChange, uid: uid)
            }
        }
    }
    
    //email functions
    func sendEmail(subject: String, nameChange: String, numberChange: String, schoolChange: String, credentialChange: String, uid: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["hills.studycloud@gmail.com"])
            mail.setSubject(subject)
            mail.setMessageBody("<p>\(nameChange) <br><br>\(numberChange) <br><br>\(schoolChange) <br><br>\(credentialChange) <br><br> \(uid) </p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print("There was an error: \(error.localizedDescription)")
        } else {
            controller.dismiss(animated: true)
            let profile = self.storyboard?.instantiateViewController(identifier: Constants.Storyoard.profileViewController) as? ProfileViewController
            self.view.window?.rootViewController = profile
            self.view.window?.makeKeyAndVisible()
        }
        
    }
}
