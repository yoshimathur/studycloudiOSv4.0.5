//
//  Constants.swift
//  TutorHub
//
//  Created by Yash Mathur on 3/17/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import Foundation
import UIKit
import CSVImporter

struct Constants {
    
    struct Storyoard {
        
        static let profileViewController = "ProfileVC"
        static let badSignUpViewController = "BadSignUpVC"
        static let signUpViewController = "SignUpVC"
        static let logInViewController = "LogInVC"
        static let homeViewController = "HomeStoryBoard"
        static let enterNameViewController = "EnterName"
        static let selectSchoolViewControlller = "SelectSchoolVC"
        static let selectGradeViewController = "SelectGradeVC"
        static let addCoursesViewController = "AddCourseVC"
        static let addTeachersViewController = "AddTeacherVC"
        static let messagesViewController = "MessagesVC"
        static let chatViewController = "ChatVC"
        
    }
    
    struct Colors {
        
        static let studycloudblueUI = UIColor.init(red: 0.36, green: 0.8, blue: 1, alpha: 1)
        static let studycloudblueCG = CGColor.init(red: 0.36, green: 0.8, blue: 1, alpha: 1)
        static let studycloudredUI = UIColor.init(red: 0.72, green: 0.116, blue: 0, alpha: 1)
        static let studycloudredCG = CGColor.init(red: 0.72, green: 0.116, blue: 0, alpha: 1)
    }
}

struct Courses {
    
    static let fullCoursesArray: [String] = ["Algebra 1", "Honors Algebra 1", "Geometry", "Honors Geometry", "Algebra 2", "Honors Algebra 2", "Pre-Calculus", "Honors Pre-Calculus", "Calculus AB", "Honors Calculus AB", "AP Calculus AB", "Calculus BC", "Honors Calculus BC", "AP Calculus BC", "Language Arts and Literature 1", "Honors Language Arts and Literature 1", "Language Arts and Literature 2", "Honors Language Arts and Literature 2", "Language Arts and Literature 3", "Honors Language Arts and Literature 3", "AP English Language and Composition", "Language Arts and Literature 4", "Honors Language Arts and Literature 4", "AP English Literature and Composition", "Biology", "Honors Biology", "AP Biology", "Chemistry", "Honors Chemistry", "AP Chemistry", "Physics 1", "Honors Physics 1", "AP Physics 1", "AP Physics 2", "AP Physics C Mechanics", "AP Physics C Electricity and Magnetism", "World History", "Honors World History", "AP World History: Modern", "U.S History", "Honors U.S History", "AP U.S History", "AP U.S Government and Politics", "Spanish 1", "Honors Spanish 1", "Spanish 2", "Honors Spanish 2", "Spanish 3", "Honors Spanish 3", "Spanish 4", "Honors Spanish 4", "AP Spanish", "French 1", "Honors French 1", "French 2", "Honors French 2", "French 3", "Honors French 3", "French 4", "Honors French 4", "AP French", "Italian 1", "Honors Italian 1", "Italian 2", "Honors Italian 2", "Italian 3", "Honors Italian 3", "Italian 4", "Honors Italian 4", "AP Italian", "German 1", "Honors German 1", "German 2", "Honors German 2", "German 3", "Honors German 3", "German 4", "Honors German 4", "AP German", "Japanese 1", "Honors Japanese 1", "Japanese 2", "Honors Japanese 2", "Japanese 3", "Honors Japanese 3", "Japanese 4", "Honors Japanese 4", "AP Japanese", "Chinese 1", "Honors Chinese 1", "Chinese 2", "Honors Chinese 2", "Chinese 3", "Honors Chinese 3", "Chinese 4", "Honors Chinese 4", "AP Chinese", "Latin 1", "Honors Latin 1", "Latin 2", "Honors Latin 2", "Latin 3", "Honors Latin 3", "Latin 4", "Honors Latin 4", "AP Latin", "AP Computer Science A", "AP Computer Science Principles", "AP Statistics", "AP Art History", "AP Music Theory", "AP Comparative Government and Politics", "AP European History", "AP Human Geography", "AP Macroeconomics", "AP Microeconomics", "AP Psychology"]
    
    static let mathCoursesArray: [String] = ["Algebra 1", "Honors Algebra 1", "Geometry", "Honors Geometry", "Algebra 2", "Honors Algebra 2", "Pre-Calculus", "Honors Pre-Calculus", "Calculus AB", "Honors Calculus AB", "AP Calculus AB", "Calculus BC", "Honors Calculus BC", "AP Calculus BC"]
    static let lalCoursesArray: [String] = ["Language Arts and Literature 1", "Honors Language Arts and Literature 1", "Language Arts and Literature 2", "Honors Language Arts and Literature 2", "Language Arts and Literature 3", "Honors Language Arts and Literature 3", "AP English Language and Composition", "Language Arts and Literature 4", "Honors Language Arts and Literature 4", "AP English Literature and Composition"]
    static let scienceCoursesArray: [String] = ["Biology", "Honors Biology", "AP Biology", "Chemistry", "Honors Chemistry", "AP Chemistry", "Physics 1", "Honors Physics 1", "AP Physics 1", "AP Physics 2", "AP Physics C Mechanics", "AP Physics C Electricity and Magnetism"]
    static let historyCoursesArray: [String] = ["World History", "Honors World History", "AP World History: Modern", "U.S History", "Honors U.S History", "AP U.S History", "AP U.S Government and Politics"]
    static let spanishCoursesArray: [String] = ["Spanish 1", "Honors Spanish 1", "Spanish 2", "Honors Spanish 2", "Spanish 3", "Honors Spanish 3", "Spanish 4", "Honors Spanish 4", "AP Spanish"]
    static let frenchCoursesArray: [String] = ["French 1", "Honors French 1", "French 2", "Honors French 2", "French 3", "Honors French 3", "French 4", "Honors French 4", "AP French"]
    static let italianCoursesArray: [String] = ["Italian 1", "Honors Italian 1", "Italian 2", "Honors Italian 2", "Italian 3", "Honors Italian 3", "Italian 4", "Honors Italian 4", "AP Italian"]
    static let germanCoursesArray: [String] = ["German 1", "Honors German 1", "German 2", "Honors German 2", "German 3", "Honors German 3", "German 4", "Honors German 4", "AP German"]
    static let japaneseCoursesArray: [String] = ["Japanese 1", "Honors Japanese 1", "Japanese 2", "Honors Japanese 2", "Japanese 3", "Honors Japanese 3", "Japanese 4", "Honors Japanese 4", "AP Japanese"]
    static let chineseCoursesArray: [String] = ["Chinese 1", "Honors Chinese 1", "Chinese 2", "Honors Chinese 2", "Chinese 3", "Honors Chinese 3", "Chinese 4", "Honors Chinese 4", "AP Chinese"]
    static let latinCoursesArray: [String] = ["Latin 1", "Honors Latin 1", "Latin 2", "Honors Latin 2", "Latin 3", "Honors Latin 3", "Latin 4", "Honors Latin 4", "AP Latin"]
    static let electiveCoursesArray: [String] = ["AP Computer Science A", "AP Computer Science Principles", "AP Statistics", "AP Art History", "AP Music Theory", "AP Comparative Government and Politics", "AP European History", "AP Human Geography", "AP Macroeconomics", "AP Microeconomics", "AP Psychology"]
    
}


struct SchoolsData {
    
    static let schools: [String] = Array(CSVImporter<[String]>(path: Bundle.main.path(forResource: "Study Cloud Schools", ofType: "csv")!).importRecords{$0}.joined())
    
    static let schoolCodes: [String] = Array(CSVImporter<[String]>(path: Bundle.main.path(forResource: "School Codes", ofType: "csv")!).importRecords{$0}.joined())
    
    static let adminCodes: [String] = Array(CSVImporter<[String]>(path: Bundle.main.path(forResource: "Admin Codes", ofType: "csv")!).importRecords{$0}.joined())
    
    static let schoolsByCodesDic = Dictionary(uniqueKeysWithValues: zip(Array(CSVImporter<[String]>(path: Bundle.main.path(forResource: "School Codes", ofType: "csv")!).importRecords{$0}.joined()), Array(CSVImporter<[String]>(path: Bundle.main.path(forResource: "Study Cloud Schools", ofType: "csv")!).importRecords{$0}.joined())))
    
}



