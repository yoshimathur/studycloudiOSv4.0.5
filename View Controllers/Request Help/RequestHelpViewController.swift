//
//  RequestHelpViewController.swift
//  TutorHub
//
//  Created by Yash Mathur on 3/24/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase

class RequestHelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print("View has loaded :)")
    }
    
    //user school and grade
    let personals: [Any] = UserDefaults.standard.value(forKey: "Personals") as! [Any]
    
    //reference to the color for the chat swipe background
    let blue = UIColor.init(red: 154/255, green: 191/255, blue: 255/255, alpha: 1)
    
    //variables for the selected helper
    var selectedUserUID: String = ""
    var selectedUserName: String? = ""
    var currentUserName: String? = ""
    
    //error label for empty arrays
    @IBOutlet weak var errorLabel: UILabel!
    
    //references for tableview and searchbar
    @IBOutlet weak var requestHelpTableView: UITableView!
    @IBOutlet weak var requestHelpSearchBar: UISearchBar!
    
    //navBar
    @IBOutlet weak var navBar: UIView!
    
    //subject scroll view
    @IBOutlet var subjectGroupButtons: [UIButton]!
    
    //local or cloud buttons
    @IBOutlet weak var searchLocalButtonRef: UIButton!
    @IBOutlet weak var searchCloudButtonRef: UIButton!
    
    //setting up elements
    func setUpElements() {
        
        print(personals)
        
        //nav bar
        navBar.layer.borderWidth = 3
        navBar.layer.borderColor = Constants.Colors.studycloudblueCG
        
        //error label
        self.errorLabel.alpha = 0
        self.errorLabel.text = ""
        
        //table view
        self.requestHelpTableView.rowHeight = 110
        
        //subject scroll bar
        for button in subjectGroupButtons {
            button.layer.cornerRadius = 10
            button.setTitleColor(.white, for: .disabled)
            button.setTitleColor(.black, for: .normal)
        }
        
        //local or cloud buttons
        searchLocalButtonRef.layer.cornerRadius = 10
        searchLocalButtonRef.isEnabled = false
        searchLocalButtonRef.backgroundColor = Constants.Colors.studycloudredUI
        searchLocalButtonRef.setTitleColor(.white, for: .disabled)
        searchLocalButtonRef.setTitleColor(.black, for: .normal)
        searchCloudButtonRef.layer.cornerRadius = 10
        searchCloudButtonRef.setTitleColor(.white, for: .disabled)
        searchCloudButtonRef.setTitleColor(.black, for: .normal)
    } //Set Up Elements
    
    
    //the searchingHelpers array is an array that is made up of the helpers that have taken the course that the current user has searched for
    var searchingHelpers: [String] = []
    var searchingHelpersDescription: [String] = []
    var searchingHelpersUID: [String] = []
    var searching = false
    
    //courses and teachers array
    var coursesArray: [String] = Courses.fullCoursesArray.map{ $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
    
    //search filter
    var filter: String = "Local"
    //Firebase ref
    let db = Firestore.firestore()
    //saving the search state
    var search: String = ""

    
    //function to clear error Label when you start typing again
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.errorLabel.alpha = 0
        self.errorLabel.text = ""
        self.search = ""
        
        //resetting buttons
        for button in self.subjectGroupButtons {
            button.isEnabled = true
            button.backgroundColor = Constants.Colors.studycloudblueUI
        } //for-in
    } //Search Bar Text Did Begin Editing
    
    
    //function for the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //saving the text in the search bar as the selected course that the user needs help in
        search = searchBar.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.courseSearch(search: search)
    } //Search Bar Button Clicked
    
    //subject group searches
    @IBAction func mathSearch(_ sender: Any) {
        self.search = "Math"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(0)
        
        self.courseGroupSearch(array: Courses.mathCoursesArray)
    } //Math Search Button Action
    @IBAction func lalSearch(_ sender: Any) {
        self.search = "LAL"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(1)
        
        self.courseGroupSearch(array: Courses.lalCoursesArray)
    } //LAL Search Button Action
    @IBAction func scienceSearch(_ sender: Any) {
        self.search = "Science"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(2)
        
        self.courseGroupSearch(array: Courses.scienceCoursesArray)
    } //Science Search Button Action
    @IBAction func historySearch(_ sender: Any) {
        self.search = "History"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(3)
        
        self.courseGroupSearch(array: Courses.historyCoursesArray)
    } //History Search Button Action
    @IBAction func spanishSearch(_ sender: Any) {
        self.search = "Spanish"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(4)
        
        self.courseGroupSearch(array: Courses.spanishCoursesArray)
    } //Spanish Search Button Action
    @IBAction func frenchSearch(_ sender: Any) {
        self.search = "French"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(5)
        
        self.courseGroupSearch(array: Courses.frenchCoursesArray)
    } //French Search Button Action
    @IBAction func italianSearch(_ sender: Any) {
        self.search = "Italian"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(6)
        
        self.courseGroupSearch(array: Courses.italianCoursesArray)
    } //Italian Search Button Action
    @IBAction func germanSearch(_ sender: Any) {
        self.search = "German"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(7)
        
        self.courseGroupSearch(array: Courses.germanCoursesArray)
    } //German Search Button Action
    @IBAction func japaneseSearch(_ sender: Any) {
        self.search = "Japanese"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(8)
        
        self.courseGroupSearch(array: Courses.japaneseCoursesArray)
    } //Japanese Search Button Action
    @IBAction func chineseSearch(_ sender: Any) {
        self.search = "Chinese"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(9)
        
        self.courseGroupSearch(array: Courses.chineseCoursesArray)
    } //Chinese Search Button Action
    @IBAction func latinSearch(_ sender: Any) {
        self.search = "Latin"
        self.saveSearch(self.search)
        
        self.subjectGroupButtonSelect(10)
        
        self.courseGroupSearch(array: Courses.latinCoursesArray)
    } //Latin Search Button Action
    @IBAction func electiveSearch(_ sender: Any) {
        self.search = "Elective"
        
        self.subjectGroupButtonSelect(11)
        
        self.courseGroupSearch(array: Courses.electiveCoursesArray)
    } //Elective Search Button Action
    
    func subjectGroupButtonSelect(_ buttonIndex: Int) {
        //return all other buttons to normal
        self.errorLabel.text = ""
        self.errorLabel.alpha = 0
        requestHelpSearchBar.text = ""
        subjectGroupButtons[buttonIndex].backgroundColor = Constants.Colors.studycloudredUI
        subjectGroupButtons[buttonIndex].isEnabled = false
        
        for button in self.subjectGroupButtons {
            if button == self.subjectGroupButtons[buttonIndex] {
                continue
            }
            button.backgroundColor = Constants.Colors.studycloudblueUI
            button.isEnabled = true
        } //for-in
    } //Subject Group Button Select
    
    @IBAction func localSearch(_ sender: Any) {
        
        self.filter = "Local"
        
        self.errorLabel.text = ""
        self.errorLabel.alpha = 0
        self.searchLocalButtonRef.backgroundColor = Constants.Colors.studycloudredUI
        self.searchLocalButtonRef.isEnabled = false
        self.searchCloudButtonRef.backgroundColor = Constants.Colors.studycloudblueUI
        self.searchCloudButtonRef.isEnabled = true
        
        switch self.search {
        case "Math":
            self.courseGroupSearch(array: Courses.mathCoursesArray)
            break
        case "LAL":
            self.courseGroupSearch(array: Courses.lalCoursesArray)
            break
        case "Science":
            self.courseGroupSearch(array: Courses.scienceCoursesArray)
            break
        case "History":
            self.courseGroupSearch(array: Courses.historyCoursesArray)
            break
        case "Spanish":
            self.courseGroupSearch(array: Courses.spanishCoursesArray)
            break
        case "French":
            self.courseGroupSearch(array: Courses.frenchCoursesArray)
            break
        case "Italian":
            self.courseGroupSearch(array: Courses.italianCoursesArray)
            break
        case "German":
            self.courseGroupSearch(array: Courses.germanCoursesArray)
            break
        case "Japanese":
            self.courseGroupSearch(array: Courses.spanishCoursesArray)
            break
        case "Chinese":
            self.courseGroupSearch(array: Courses.chineseCoursesArray)
            break
        case "Elective":
            self.courseGroupSearch(array: Courses.electiveCoursesArray)
            break
        default:
            self.courseSearch(search: self.search)
            break
        } //switch search
    } //Local Search
    
    @IBAction func searchCloud(_ sender: Any) {
        
        self.filter = "Cloud"
        
        self.errorLabel.text = ""
        self.errorLabel.alpha = 0
        self.searchCloudButtonRef.backgroundColor = Constants.Colors.studycloudredUI
        self.searchCloudButtonRef.isEnabled = false
        self.searchLocalButtonRef.backgroundColor = Constants.Colors.studycloudblueUI
        self.searchLocalButtonRef.isEnabled = true
        
        switch self.search {
        case "Math":
            self.courseGroupSearch(array: Courses.mathCoursesArray)
            break
        case "LAL":
            self.courseGroupSearch(array: Courses.lalCoursesArray)
            break
        case "Science":
            self.courseGroupSearch(array: Courses.scienceCoursesArray)
            break
        case "History":
            self.courseGroupSearch(array: Courses.historyCoursesArray)
            break
        case "Spanish":
            self.courseGroupSearch(array: Courses.spanishCoursesArray)
            break
        case "French":
            self.courseGroupSearch(array: Courses.frenchCoursesArray)
            break
        case "Italian":
            self.courseGroupSearch(array: Courses.italianCoursesArray)
            break
        case "German":
            self.courseGroupSearch(array: Courses.germanCoursesArray)
            break
        case "Japanese":
            self.courseGroupSearch(array: Courses.japaneseCoursesArray)
            break
        case "Chinese":
            self.courseGroupSearch(array: Courses.chineseCoursesArray)
            break
        case "Elective":
            self.courseGroupSearch(array: Courses.electiveCoursesArray)
            break
        default:
            self.courseSearch(search: self.search)
            break
        } //switch search
    } //Search Cloud
    
    
    
    //function to handle a course search
    func courseSearch(search: String) {
        let grade: String? = personals[3] as? String
        let district: Int? = personals[2] as? Int
        print(district ?? "No Value", grade ?? "No Value")
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            
            if let grade = grade, let district = district {
                
                switch grade {
                
                case "Underclassman":
                    //the user is an underclassman
                    
                    //clearing out the searchers array before running a new search
                    self.clearArrays()
                    
                    switch filter {
                    case "Local":
                        var count = 0
                        
                        db.collection("Users")
                            .whereField("District", isEqualTo: district)
                            .whereField("Helper", isEqualTo: true)
                            .order(by: "Tag")
                            .getDocuments { (querySnapshot, error) in
                                if let error = error {
                                    self.handleError(error: error)
                                } else {
                                    for document in querySnapshot!.documents {
                                        if count == 15 {
                                            break
                                        }
                                        self.errorLabel.alpha = 0
                                        self.errorLabel.text = ""
                                        self.addHelperData(document: document)
                                        count += 1
                                    }//for-in
                                    
                                    //making sure helpers list is not empty
                                    if self.searchingHelpers.count == 0 {
                                        self.saveSearch(search)
                                        self.errorLabel.text = "No local helpers could be found! Try searching the cloud!"
                                        self.errorLabel.alpha = 1
                                    } //if
                                    
                                } //if-else
                            } //Get Documents
                        break
                    case "Cloud":
                        var count = 0
                        
                        db.collection("Users")
                            .whereField("Helper", isEqualTo: true)
                            .order(by: "Tag")
                            .getDocuments { (querySnapshot, error) in
                                if let error = error {
                                    self.handleError(error: error)
                                } else {
                                    for document in querySnapshot!.documents {
                                        if count == 15 {
                                            break
                                        }
                                        self.errorLabel.alpha = 0
                                        self.errorLabel.text = ""
                                        self.addHelperData(document: document)
                                        count += 1
                                    } //for-in
                                    
                                    //making sure helpers list is not empty
                                    if self.searchingHelpers.count == 0 {
                                        self.saveSearch(search)
                                        self.errorLabel.text = "No helpers could be found! Spread word of about the app to get the help you need!"
                                        self.errorLabel.alpha = 1
                                    } //if
                                } //if-else
                            } //Get Documents
                        break
                    default:
                        fatalError()
                        break
                    } //switch filter
                    break
                    
                default:
                    //user is not an underclassman
                    if coursesArray.contains(search) == true {
                        
                        //getting index of search
                        let courseIndex: Int = coursesArray.firstIndex(of: search)!
                        
                        //clearing out the searchers array before running a new search
                        self.clearArrays()
                        
                        switch filter {
                        case "Local":
                            var count = 0
                            
                            db.collection("Users")
                                .whereField("District", isEqualTo: district)
                                .whereField("Helper", isEqualTo: true)
                                .order(by: "Tag")
                                .getDocuments { (querySnapshot, error) in
                                    if let error = error {
                                        self.handleError(error: error)
                                    } else {
                                        for document in querySnapshot!.documents {
                                            if count == 15 {
                                                break
                                            }
                                            if document.documentID != uid {
                                                let courses = document.get("Courses") as? [Int]
                                                if let courses = courses {
                                                    if courses.contains(courseIndex) {
                                                        self.errorLabel.alpha = 0
                                                        self.errorLabel.text = ""
                                                        self.addHelperData(document: document)
                                                        count += 1
                                                    } else {
                                                        print("This user does not take the searched course.")
                                                    } //if-else
                                                } //if
                                            } //if
                                        } //for-in
                                       //making sure helpers list is not empty
                                        if self.searchingHelpers.count == 0 {
                                            self.saveSearch(search)
                                            self.errorLabel.text = "No local helpers could be found! Try searching the cloud!"
                                            self.errorLabel.alpha = 1
                                        } //if
                                    } //if-else
                                } //Get Documents
                            break
                        case "Cloud":
                            var count = 0
                            
                            db.collection("Users")
                                .whereField("Helper", isEqualTo: true)
                                .order(by: "Tag")
                                .limit(to: 25)
                                .getDocuments { (querySnapshot, error) in
                                    if let error = error {
                                        self.handleError(error: error)
                                    } else {
                                        for document in querySnapshot!.documents {
                                            if count == 15 {
                                                break
                                            }
                                            if document.documentID != uid {
                                                let courses = document.get("Courses") as? [Int]
                                                if let courses = courses {
                                                    if courses.contains(courseIndex) {
                                                        self.errorLabel.alpha = 0
                                                        self.errorLabel.text = ""
                                                        self.addHelperData(document: document)
                                                        count += 1
                                                    } else {
                                                        print("This user does not take the searched course.")
                                                    } //if-eles
                                                } //if
                                            } //if
                                        } //for-in
                                        //making sure helpers list is not empty
                                        if self.searchingHelpers.count == 0 {
                                            self.saveSearch(search)
                                            self.errorLabel.text = "No helpers could be found! Spread word of the app to get the help you need!"
                                            self.errorLabel.alpha = 1
                                        } //if
                                    } //if-else
                                } //Get Documents
                            break
                        default:
                            fatalError()
                        } //switch filter
                        
                    } else {
                        //result was not valid
                        self.errorLabel.text = "No results. Invalid search! Check Program of Studies to make sure you are searching for a valid course name."
                        self.errorLabel.alpha = 1
                        self.searchingHelpers.removeAll()
                        self.searchingHelpersDescription.removeAll()
                        self.searchingHelpersUID.removeAll()
                        self.requestHelpTableView.reloadData()
                        self.view.endEditing(true)
                    } //if-else
                } //switch grade
            } //if
        } //if
        
        self.searching = true
        self.requestHelpTableView.reloadData()
    } //Course Search
    
    //function to handle course group search
    func courseGroupSearch(array: [String]) {
        let user = Auth.auth().currentUser
        let district: Int? = personals[2] as? Int
        print(district ?? "No Value")
        if let user = user {
            let uid = user.uid
            
            //clearing arrays
            self.clearArrays()
            
            if let district = district {
                
                switch filter {
                case "Local":
                    var count = 0
                    
                    db.collection("Users")
                        .whereField("District", isEqualTo: district)
                        .whereField("Helper", isEqualTo: true)
                        .order(by: "Tag")
                        .getDocuments { (querySnapshot, error) in
                            if let error = error {
                                self.handleError(error: error)
                            } else {
                                for document in querySnapshot!.documents {
                                    if count == 15 {
                                        break
                                    }
                                    if document.documentID != uid {
                                        let courses = document.get("Courses") as? [Int]
                                        if let courses = courses {
                                            for i in courses {
                                                let course = Courses.fullCoursesArray[i]
                                                if array.contains(course) {
                                                    self.addHelperData(document: document)
                                                    count += 1
                                                    break
                                                } //if
                                            } //for-in
                                        } //if
                                    } //if
                                } //for-in
                                if self.searchingHelpers.count == 0 {
                                    self.errorLabel.text = "No local helpers could be found for this subject area! Try searching the cloud!"
                                    self.errorLabel.alpha = 1
                                } //if
                            } //if-else
                        } //Get Documents
                case "Cloud":
                    var count = 0
                    
                    db.collection("Users")
                        .whereField("Helper", isEqualTo: true)
                        .order(by: "Tag")
                        .getDocuments { (querySnapshot, error) in
                            if let error = error {
                                self.handleError(error: error)
                            } else {
                                for document in querySnapshot!.documents {
                                    if count == 15 {
                                        break
                                    }
                                    if document.documentID != uid {
                                        let courses = document.get("Courses") as? [Int]
                                        if let courses = courses {
                                            for i in courses {
                                                let course = Courses.fullCoursesArray[i]
                                                if array.contains(course) {
                                                    self.addHelperData(document: document)
                                                    count += 1
                                                    break
                                                } //if
                                            } //for-in
                                        } //if
                                    } //if
                                } //if
                                if self.searchingHelpers.count == 0 {
                                    self.errorLabel.text = "No helpers could be found for this subject area! Spread word of about the app to get the help you need!"
                                    self.errorLabel.alpha = 1
                                } //if
                            } //if-else
                        } //Get Documents
                default:
                    fatalError()
                } //switch filter
                self.searching = true
                self.requestHelpTableView.reloadData()
            } else {
                print("Error with district: \(String(describing: district))")
            }
        }
    }
    
    //function to handle errors
    func handleError(error: Error) {
        print("Error in getting document: \(error.localizedDescription)")
        self.errorLabel.text = error.localizedDescription
        self.errorLabel.alpha = 1
    } //Handle Error
    
    //function to clear arrays
    func clearArrays() {
        self.searchingHelpers.removeAll()
        self.searchingHelpersDescription.removeAll()
        self.searchingHelpersUID.removeAll()
    } //Clear Arrays
    
    //function to add helper data to arrays
    func addHelperData(document: QueryDocumentSnapshot) {
        let helperName: String? = document.get("Name") as? String
        let helperGrade: String? = document.get("Grade") as? String
        let helperSchoolCode: String? = document.get("School") as? String
        var helperSchool: String? = nil
        if let code = helperSchoolCode {
            helperSchool = SchoolsData.schoolsByCodesDic[code]
        }
        let helperUID: String = document.documentID
        let helperDescription = "\(helperGrade ?? "No Information") at \(helperSchool ?? "No Information")"
        self.searchingHelpers.append(helperName ?? "No Name")
        self.searchingHelpersDescription.append(helperDescription)
        self.searchingHelpersUID.append(helperUID)
        self.requestHelpTableView.reloadData()
        self.view.endEditing(true)
    } //Add Helper Data
    
    //necesarry tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingHelpers.count
        } else {
            return 0
        }
    } //Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RequestHelpTableViewCell = tableView.dequeueReusableCell(withIdentifier: "requestedHelpCell") as! RequestHelpTableViewCell
        if searching {
            cell.name.text = searchingHelpers[indexPath.row]
            cell.userDescription.text = searchingHelpersDescription[indexPath.row]
            cell.userDescription.numberOfLines = 0
            cell.profileImage.layer.cornerRadius = 50
        } else {
            
        }
        return cell
    } //Table View
    //selecting a helper
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: RequestHelpTableViewCell = tableView.dequeueReusableCell(withIdentifier: "requestedHelpCell") as! RequestHelpTableViewCell
        cell.selectionStyle = .gray
        if self.searching {
            self.selectedUserUID = searchingHelpersUID[indexPath.row]
        } else {
            print("error")
        }
        self.performSegue(withIdentifier: "RequestHelpToUser2ProfileDescription", sender: self)
    }
    
    let defaults = UserDefaults.standard
    func saveSearch(_ search: String) {
        let array = defaults.object(forKey: "RecentSearches") as? [String]
        if var array = array {
            array.append(search)
            if array.count > 15 {
                array.remove(at: 0)
                defaults.set(array, forKey: "RecentSearches")
            } else {
                defaults.set(array, forKey: "RecentSearches")
            } //if-else
        } else {
            let newArray = [search]
            defaults.set(newArray, forKey: "RecentSearches")
        } //if-elses
    } //Save Search
    
    //override function to take user data from here to chat vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RequestHelpToChat" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.user2Name = self.selectedUserName!
            chatVC.user2UID = self.selectedUserUID
            chatVC.currentUserName = self.currentUserName!
        } else if segue.identifier == "RequestHelpToUser2ProfileDescription" {
            let profileVC = segue.destination as! SelectedUserProfileViewController
            profileVC.uid = self.selectedUserUID
            profileVC.subject = self.search
        }
    } //Prepare For Segue
    
}
