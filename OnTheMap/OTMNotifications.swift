//
//  OTMNotifications.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/3/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import FBSDKLoginKit

enum barButtonType: Int {
    case login
    case logout
}

extension OTMClient {
    
    // setup the shared navigation bar
    func setupNavigationItem(item: UINavigationItem) -> Void {
        item.title = "On The Map"
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")

        let reloadButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "postNotificationReloadData")

        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Done, target: self, action: "showInfoPostingView:")
        
        item.rightBarButtonItems = [reloadButton ,pinButton]
        item.leftBarButtonItem = logoutButton
        
        self.navigationItem = item
    }
    
    func swapLeftBarButton(button: barButtonType, item: UINavigationItem) {
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        let loginButton = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "showLoginView")
        
        item.leftBarButtonItem = nil
        
        switch button {
            case .login: return item.leftBarButtonItem = loginButton
            case .logout: return item.leftBarButtonItem = logoutButton
        }
    }
    
    func logout() {
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            // clear session
            FBSDKAccessToken.setCurrentAccessToken(nil)
            self.clearSession()
            
            println("Facebook: logged out, token cleared")
            NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoggedOut, object: nil)
        } else {
            println("Facebook: Was not logged in, No token")
            self.clearSession()
            
            OTMClient.sharedInstance().logoutOfSession { (result, error) -> Void in
                if let result = result.valueForKey(JSONResponseKeys.SessionID) as? [String: AnyObject] {

                    println("barButton: Logout \(result)")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoggedOut, object: nil)
                } else {
                    println("Logout: error")
                }
            }
        }
    }
    
    func postNotificationReloadData() {
        
        // post the notification to update the student locations
        OTMClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            if let result = result {
                // reload the student data in map and table view
                NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationReload, object: nil)
                println("Note posted")
            } else {
                println("Reload: error getting student locations")
            }
        }
    }
    
    func showInfoPostingView(sender: AnyObject) {
        // tell the delegate to show info post view when pin button tapped
        if self.sessionID != nil {
            println("show info post")
            self.delegate?.barButtonShowInfoPost()
        } else {
            println("not logged in")
            NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationInfoPostAlert, object: nil)
        }
        
    }
    
    func showLoginView() {
        println("delegate show login")
        self.delegate?.barButtonShowLogin()
    }
   
}
