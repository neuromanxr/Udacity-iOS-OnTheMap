//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        OTMClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            if let result = result {
                // got the student locations
                println("got student locations \(result)")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // update UI
                    println("updated the ui")
                })
                
            } else {
                // couldn't get the student locations
                println(error)
            }
        }
        
        OTMClient.sharedInstance().authenticateWithViewController(self, completionHandler: { (success, errorString) -> Void in
            if success {
                println("map: got the user data")
            } else {
                println("map: error \(errorString)")
            }
        })
        
        OTMClient.sharedInstance().logoutOfSession(self, completionHandler: { (result, error) -> Void in
            if let result = result {
                println("logged out \(result)")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // update UI
                    println("updated the UI")
                })
            } else {
                // couldn't log out
                println("couldn't logout \(error)")
            }
        })
        
//        OTMClient.sharedInstance().getSessionID { (success, sessionID, errorString) -> Void in
//            
//            println("result in map \(sessionID)")
//            if let session = sessionID {
//                // created new session
//                println("session id response \(session)")
//                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    println("updated the ui")
//                })
//            } else {
//                // couldn't create new session
//                println("error parse result \(errorString)")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

