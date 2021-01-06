//
//  AppDelegate.swift
//  TutorHub
//
//  Created by Yash Mathur on 2/9/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //firestore configuration
        FirebaseApp.configure()
        
        //Messaging delegate
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }
        
        //clearing the badge number when app is loaded
        application.applicationIconBadgeNumber = 0

        //push notifications
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {granted, error in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        //local notifications
        let center = UNUserNotificationCenter.current()
        
        //requesting auth
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }

        //notification content
        let content = UNMutableNotificationContent()
        content.title = "It's the start of the week!"
        content.body = "If you need help, you know where to find it!"

        //creating the trigger
        var date: Date = Date()
        let notifcationDate = DateComponents(hour: 7, weekday: 2)
        let now = Date()
        if let nextNotification = Calendar.current.nextDate(after: now, matching: notifcationDate, matchingPolicy: .strict) {
            print(DateFormatter.localizedString(from: now, dateStyle: .short, timeStyle: .short))
            print(DateFormatter.localizedString(from: nextNotification, dateStyle: .short, timeStyle: .short))
            date = nextNotification
        }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        //setting the badge number
        if date == now {
            application.applicationIconBadgeNumber = 1
        }

        //creating the trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        //creating a request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        //register the request
        center.add(request) { (error) in
        if let error = error {
            print("\(error.localizedDescription)")
            }
        }
        
        
        //function to assign a random number to the user everytime he or she comes on to the app so that we can order helpers in request help tab randomly
        if Auth.auth().currentUser != nil && UserDefaults.standard.bool(forKey: "Underclassman") == false {
            let tag = Int.random(in: 1...1000)
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).updateData(["Tag" : tag])
        }

        
        return true
                
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict:[String: String] = ["token": fcmToken ]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    //restricting landscape for iphones and portrait for iPads
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        let device = UIDevice().userInterfaceIdiom
        switch device {
        case .pad:
            return .all
        case .phone:
            return .portrait
        default:
            return .portrait
        }
    }
    
}


