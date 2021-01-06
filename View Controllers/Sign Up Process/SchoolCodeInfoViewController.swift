//
//  SchoolCodeInfoViewController.swift
//  Study Cloud
//
//  Created by Yash Mathur on 10/14/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class SchoolCodeInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print("View has loaded :)")
    }
    
    //references
    @IBOutlet weak var schoolCodeSearchBar: UISearchBar!
    @IBOutlet weak var schoolCodeTableView: UITableView!
    @IBOutlet weak var codeCopiedLabel: UILabel!
    
    //function to set up the elements
    func setUpElements() {
        
        //code label
        codeCopiedLabel.backgroundColor = .lightGray
    }
    
    //school array
    let schoolsArray = SchoolsData.schools
    let schoolCodes = SchoolsData.schoolCodes
    
    //searching variables
    var searchingSchoolsArray: [String] = []
    var searching = false
    
    //search bar functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setUpElements()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchingSchoolsArray = searchText.isEmpty ? self.schoolsArray : self.schoolsArray.filter({ (school: String) -> Bool in
            return school.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        self.searching = true
        self.schoolCodeTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            self.searching = false
            self.schoolCodeTableView.reloadData()
        }
        self.view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searching = false
        self.schoolCodeTableView.reloadData()
    }
    
    //necessary table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return self.searchingSchoolsArray.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCodeInfoCell")
        
        if searching {
            cell?.textLabel!.text = self.searchingSchoolsArray[indexPath.row]
        }
        
        cell?.textLabel?.numberOfLines = 0
        return cell!
    }
    
    //clicking on cell should copy the code
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var code: String = ""
        if searching {
            let school = self.searchingSchoolsArray[indexPath.row]
            code = self.schoolCodes[self.schoolsArray.firstIndex(of: school)!]
        }
        
        //copy the code
        let pasteboard = UIPasteboard.general
        pasteboard.string = code
        
        //display the label to show code was copied
        self.codeCopiedLabel.backgroundColor = Constants.Colors.studycloudblueUI
        tableView.setContentOffset(.zero, animated: true)
    }

}
