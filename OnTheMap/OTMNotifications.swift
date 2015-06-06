//
//  OTMNotifications.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/3/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

extension OTMClient {
    
    // setup the shared navigation bar
    func setupNavigationItem(item: UINavigationItem) -> Void {
        item.title = "On The Map"
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        let reloadButton = UIBarButtonItem(title: "Reload", style: UIBarButtonItemStyle.Plain, target: self, action: "postNotificationReloadData")
        let pinButton = UIBarButtonItem(title: "Pin", style: UIBarButtonItemStyle.Plain, target: self, action: "showInfoPostingView:")
        item.rightBarButtonItems = [reloadButton ,pinButton]
        item.leftBarButtonItem = logoutButton
    }
    
    func logout() {
        OTMClient.sharedInstance().logoutOfSession { (result, error) -> Void in
            if let result = result {
                println("Logout: \(result)")
                
                NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoggedOut, object: nil)
            } else {
                println("Logout: error")
            }
        }
    }
    
    func postNotificationReloadData() {
        
        // post the notification to update the student locations
        OTMClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            if let result = result {
                
                NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationReload, object: nil)
                println("Note posted")
            } else {
                println("Reload: error getting student locations")
            }
        }
    }
    
    func showInfoPostingView(sender: AnyObject) {
        
        println("info post SENDER: \(sender)")
        NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationShowInfoPost, object: sender)
    }
   
}
