//
//  AdminHomeViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 8/23/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class AdminChatControlViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        setUpChatSwitch()
        setUpArrays()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print("View has loaded :)")
    }
    
    //references
    @IBOutlet weak var enableChatSwitch: UISwitch!
    @IBOutlet weak var dailyAMHourTextField: UITextField!
    @IBOutlet weak var dailyPMHourTextField: UITextField!
    @IBOutlet weak var halfDayAMHourTextField: UITextField!
    @IBOutlet weak var halfDayPMHourTextField: UITextField!
    @IBOutlet weak var dailyErrorLabel: UILabel!
    @IBOutlet weak var halfDayErrorLabel: UILabel!
    @IBOutlet weak var halfDaysDatePicker: UIDatePicker!
    @IBOutlet weak var halfDaysTableView: UITableView!
    @IBOutlet weak var holidaysDatePicker: UIDatePicker!
    @IBOutlet weak var holidaysTableView: UITableView!
    
    //variables to be brought over from admin log in
    var school: String? = ""
    
    //arrays
    var halfDaysArray: [String] = []
    var holidaysArray: [String] = []
    
    func setUpElements() {
        
        //error labels
        dailyErrorLabel.alpha = 0
        halfDayErrorLabel.alpha = 0
        
        //textfields for the hours
        dailyAMHourTextField.layer.borderColor = CGColor(srgbRed: 154/255, green: 191/255, blue: 1, alpha: 1)
        dailyAMHourTextField.layer.borderWidth = 1
        dailyAMHourTextField.layer.cornerRadius = 5
        dailyAMHourTextField.delegate = self
        
        dailyPMHourTextField.layer.borderColor = CGColor(srgbRed: 154/255, green: 191/255, blue: 1, alpha: 1)
        dailyPMHourTextField.layer.borderWidth = 1
        dailyPMHourTextField.layer.cornerRadius = 5
        dailyPMHourTextField.delegate = self
        
        halfDayAMHourTextField.layer.borderColor = CGColor(srgbRed: 154/255, green: 191/255, blue: 1, alpha: 1)
        halfDayAMHourTextField.layer.borderWidth = 1
        halfDayAMHourTextField.layer.cornerRadius = 5
        halfDayAMHourTextField.delegate = self
        
        halfDayPMHourTextField.layer.borderColor = CGColor(srgbRed: 154/255, green: 191/255, blue: 1, alpha: 1)
        halfDayPMHourTextField.layer.borderWidth = 1
        halfDayPMHourTextField.layer.cornerRadius = 5
        halfDayPMHourTextField.delegate = self
        
        //table views
        halfDaysTableView.allowsSelection = false
        holidaysTableView.allowsSelection = false
        halfDaysTableView.separatorColor = UIColor.init(named: "Study Cloud Button Color ")
        holidaysTableView.separatorColor = UIColor.init(named: "Study Cloud Button Color ")
        
        setUpHours()
    }
    
    //Enable Chat Switch
    @IBAction func enableChatToggle(_ sender: Any) {
        if enableChatSwitch.isOn {
            if let school = school {
                let db = Firestore.firestore()
                db.collection("Admins").document(school).updateData(["Chat" : true])
            }
        } else {
            if let school = school {
                let db = Firestore.firestore()
                db.collection("Admins").document(school).updateData(["Chat" : false])
            }
        }
    }
    
    //function to set up the enable chat switch
    func setUpChatSwitch() {
        if let school = school {
            let db = Firestore.firestore()
            db.collection("Admins").document(school).getDocument { (document, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    if let document = document {
                        let switchstate: Bool? = document.get("Chat") as? Bool
                        self.enableChatSwitch.isOn = switchstate ?? false
                    }
                }
            }
        }
    }
    
    
    //saving changes to the daily hours
    @IBAction func dailySaveChanges(_ sender: Any) {
        if dailyAMHourTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || dailyPMHourTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            dailyErrorLabel.text = "Please fill in all fields!"
            dailyErrorLabel.alpha = 0
        } else if isHour(dailyAMHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false || isHour(dailyPMHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false {
            dailyErrorLabel.text = "Please enter valid hours!"
            dailyErrorLabel.alpha = 1
        } else {
            dailyErrorLabel.alpha = 0
            var amHour = Int(dailyAMHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))!
            if amHour == 12 {
                amHour = 0
            }
            var pmHour = Int(dailyPMHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))! + 12
            if pmHour == 24 {
                pmHour = 12
            }
            print(amHour, pmHour)
            if let school = school {
                let db = Firestore.firestore()
                let hours: [Int] = [amHour, pmHour]
                db.collection("Admins").document(school).updateData(["Hours" : hours])
                setUpHours()
            }
        }
    }
    
    //saving changes to the half day hours
    @IBAction func halfDaySaveChanges(_ sender: Any) {
        if halfDayAMHourTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || halfDayPMHourTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            halfDayErrorLabel.text = "Please fill in all fields!"
            halfDayErrorLabel.alpha = 0
        } else if isHour(halfDayAMHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false || isHour(halfDayPMHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false {
            halfDayErrorLabel.text = "Please enter valid hours!"
            halfDayErrorLabel.alpha = 1
        } else {
            halfDayErrorLabel.alpha = 0
            var amHour = Int(halfDayAMHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))!
            if amHour == 12 {
                amHour = 0
            }
            var pmHour = Int(halfDayPMHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))! + 12
            if pmHour == 24 {
                pmHour = 12
            }
            print(amHour, pmHour)
            if let school = school {
                let db = Firestore.firestore()
                let hours: [Int] = [amHour, pmHour]
                db.collection("Admins").document(school).updateData(["HalfHours" : hours])
                setUpHours()
            }
        }
    }
    
    //adding a half day date
    @IBAction func addHalfDay(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = self.halfDaysDatePicker.date
        let dateString = formatter.string(from: date)
        if self.halfDaysArray.contains(dateString) == false {
            self.halfDaysArray.append(dateString)
        }
        self.halfDaysTableView.reloadData()
    }
    @IBAction func addHalfDaySaveChanges(_ sender: Any) {
        if let school = school {
            let db = Firestore.firestore()
            db.collection("Admins").document(school).updateData(["Half Days" : self.halfDaysArray])
        }
    }
    
    //adding a holiday date
    @IBAction func addHolidayDate(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = self.holidaysDatePicker.date
        let dateString = formatter.string(from: date)
        if self.holidaysArray.contains(dateString) == false {
            self.holidaysArray.append(dateString)
        }
        self.holidaysTableView.reloadData()
    }
    @IBAction func addHolidaysSaveChanges(_ sender: Any) {
        if let school = school {
            let db = Firestore.firestore()
            db.collection("Admins").document(school).updateData(["Holidays" : self.holidaysArray])
        }
    }
    
    //funciton to set up the arrays
    func setUpArrays() {
        if let school = school {
            let db = Firestore.firestore()
            db.collection("Admins").document(school).getDocument { (document, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    if let document = document {
                        self.halfDaysArray = document.get("Half Days") as! [String]
                        self.holidaysArray = document.get("Holidays") as! [String]
                        self.halfDaysTableView.reloadData()
                        self.holidaysTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if tableView == self.halfDaysTableView {
            count = halfDaysArray.count
        } else if tableView == self.holidaysTableView {
            count = holidaysArray.count
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if tableView == self.halfDaysTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "halfDayCell")
            cell?.textLabel?.text = self.halfDaysArray.reversed()[indexPath.row]
        } else if tableView == self.holidaysTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "holidayCell")
            cell?.textLabel?.text = self.holidaysArray.reversed()[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            if tableView == self.halfDaysTableView {
                let deletedDate = self.halfDaysArray.reversed()[indexPath.row]
                let dateIndex: Int = Int(self.halfDaysArray.firstIndex(of: deletedDate)!)
                self.halfDaysArray.remove(at: dateIndex)
                self.halfDaysTableView.reloadData()
            } else if tableView == self.holidaysTableView {
                let deletedDate = self.holidaysArray.reversed()[indexPath.row]
                let dateIndex: Int = Int(self.holidaysArray.firstIndex(of: deletedDate)!)
                self.holidaysArray.remove(at: dateIndex)
                self.holidaysTableView.reloadData()
            }
        }
        deleteAction.backgroundColor = UIColor.red
        let delete = UISwipeActionsConfiguration(actions: [deleteAction])
        return delete
    }
    
    //set up the hours in the text fields
    func setUpHours() {
        if let school = school {
            let db = Firestore.firestore()
            db.collection("Admins").document(school).getDocument { (document, error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                } else {
                    if let document = document {
                        let hours: [Int]? = document.get("Hours") as? [Int]
                        let halfHours: [Int]? = document.get("HalfHours") as? [Int]
                        var dailyAM = hours?[0] ?? 0
                        if dailyAM == 0 {
                            dailyAM = 12
                        }
                        self.dailyAMHourTextField.text = "\(dailyAM)"
                        var dailyPM = (hours?[1] ?? 0) - 12
                        if dailyPM <= 0 {
                            dailyPM = 12
                        }
                        self.dailyPMHourTextField.text = "\(dailyPM)"
                        var halfDayAM = halfHours?[0] ?? 0
                        if halfDayAM == 0 {
                            halfDayAM = 12
                        }
                        self.halfDayAMHourTextField.text = "\(halfDayAM)"
                        var halfDayPM = (halfHours?[1] ?? 0) - 12
                        if halfDayPM <= 0 {
                            halfDayPM = 12
                        }
                        self.halfDayPMHourTextField.text = "\(halfDayPM)"
                    }
                }
            }
        }
    }
    
    
    //check if text is a number
    func isHour(_ text: String) -> Bool {
        let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        for digit in digits {
            if text == digit {
                return true
            }
            if text == "0" {
                return false
            }
        }
        return false
    }
    
    //limiting the textfields to only one character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var count = 0
        if textField == self.dailyAMHourTextField || textField == self.dailyPMHourTextField || textField == self.halfDayAMHourTextField || textField == self.halfDayPMHourTextField {
            guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {return false}
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            count = textFieldText.count - substringToReplace.count + string.count
        }
        return count <= 2
    }
    
    //override to send school name back to home
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToHomeFromChatControlSegue" {
            let adminHome = segue.destination as! AdminHomeViewController
            adminHome.school = self.school
        }
    }

}
