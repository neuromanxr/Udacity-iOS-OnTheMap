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
        
        // get the session id through facebook
        OTMClient.sharedInstance().getFacebookSessionID { (success, sessionID, errorString) -> Void in
            if let session = sessionID {
                println("session id \(session)")
                OTMClient.sharedInstance().sessionID = session
                
                // then get the user data
                OTMClient.sharedInstance().getPublicUserData({ (success, result, errorString) -> Void in
                    if success {
                        println("success got user data \(result)")
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
        
        if OTMClient.sharedInstance().sessionID != nil {
            OTMClient.sharedInstance().sessionID = nil
            println("session id cleared")
        } else {
            println("session id wasn't cleared")
        }
    }
}
