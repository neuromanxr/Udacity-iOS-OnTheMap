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
    func setupNavigationItem(item: UINavigationItem) {
        println("Running Setup NAVIGATION ITEM \(item)")
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
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController as! UINavigationController
        let mainViewController = rootViewController.viewControllers.first as! UITabBarController
        
        let alertController = UIAlertController(title: "Logout", message: "Logout?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let alertConfirmAction = UIAlertAction(title: "Logout", style: UIAlertActionStyle.Destructive) { (confirm) -> Void in
            
            // if logged in facebook
            if FBSDKAccessToken.currentAccessToken() != nil {
                // clear facebook token
                FBSDKAccessToken.setCurrentAccessToken(nil)
                // and clear session
                self.clearSession()
                OTMClient.deleteSession()
                
                println("Facebook: logged out, token cleared")
                NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoggedOut, object: nil)
            } else {
                // if logged in udacity
                println("Udacity: logged out, session cleared")
                
                // show activity indicator
                OTMActivityIndicator.sharedInstance().showActivityIndicator(mainViewController.view)
                
                // clear session locally
                self.clearSession()
                OTMClient.deleteSession()
                // delete session at udacity
                OTMClient.sharedInstance().logoutOfSession { (result, error) -> Void in
                    if let result = result.valueForKey(JSONResponseKeys.SessionID) as? [String: AnyObject] {
                        
                        // hide activity indicator
                        OTMActivityIndicator.sharedInstance().hideActivityIndicator()
                        println("barButton: Logout \(result)")
                        
                        // send notification to update ui in view controllers
                        NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoggedOut, object: nil)
                    } else {
                        println("Logout: error")
                    }
                }
            }
        }
        
        let alertCancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (cancel) -> Void in
            println("cancelled")
        }
        
        alertController.addAction(alertConfirmAction)
        alertController.addAction(alertCancelAction)
        
        mainViewController.presentViewController(alertController, animated: true, completion: nil)
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
