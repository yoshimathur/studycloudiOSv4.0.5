//
//  PushNotificationSender.swift
//  Study Cloud
//
//  Created by Yash Mathur on 7/17/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationSender {
    
    func sendMessage(to token: String, title: String, body: String) {
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "badge" : 1],
                                            "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAv_XX_rk:APA91bH2ab60iTZzGWoqaDajtDsj_8LDNOxZlX0Aq5n7NjFM5Eh82ZDt6VHeRmN2bCjpx-d3dkkrMlbB36yp2Itbmw-fkx6iDMzZdGcl-F6fYR59Sm8QLcql-3QoKUz-aQHtGeCgrvtP", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

