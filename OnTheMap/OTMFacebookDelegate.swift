//
//  OTMFacebookDelegate.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/28/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class OTMFacebookDelegate: NSObject, FBSDKLoginButtonDelegate {
    
    var accessToken: String?
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("facebook logged in")
        
        // after login, change the left barButton to logout button
        NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoggedIn, object: nil)
        
        // get the session id through facebook
        OTMClient.sharedInstance().getFacebookSessionID { (success, sessionID, errorString) -> Void in
            if let session = sessionID {
                
                println("session id \(session)")
                OTMClient.sharedInstance().sessionID = session
                
                // then get the user data
                OTMClient.sharedInstance().getPublicUserData({ (success, name, errorString) -> Void in
                    if success {
                        println("success got user data \(name!)")
                        // store your name for this session
                        OTMClient.sharedInstance().yourName = name
                        
                        // tell login view controller to dismiss after facebook login
                        NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationFacebookLoggedIn, object: nil)
                        // get the student data
                        NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoadStudents, object: nil)
                        
                    } else {
                        println("failed didn't get user data")
                    }
                })
            } else {
                println("couldn't get the session id")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("facebook logged out")
        
        // after logout, change the left barButton to login button
        NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoggedOut, object: nil)
        // tell login view controller to dismiss after facebook login
        NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationFacebookLoggedIn, object: nil)
        
        if OTMClient.sharedInstance().sessionID != nil {
            
            OTMClient.sharedInstance().clearSession()
            println("session id cleared \(OTMClient.sharedInstance().sessionID)")
        } else {
            println("session id wasn't cleared \(OTMClient.sharedInstance().sessionID)")
        }
    }
}
