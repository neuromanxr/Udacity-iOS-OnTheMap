//
//  OTMLogin.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/9/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMLogin: NSObject, LoginViewControllerDelegate, OTMBarButtonDelegate {
    
    var authenticated: Bool?
    
    override init() {
        authenticated = false

        super.init()
    }
   
    class func sharedInstance() -> OTMLogin {
        
        struct Singleton {
            static var sharedInstance = OTMLogin()
        }
        return Singleton.sharedInstance
    }
    
    func didLoggedIn(status: Bool) {
        println("DELEGATE: logged in")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
            OTMClient.sharedInstance().delegate = OTMLogin.sharedInstance()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let rootViewController = appDelegate.window?.rootViewController as! UINavigationController
            rootViewController.setViewControllers([mainView], animated: true)
        })
    }
    
    func barButtonShowInfoPost() {
        println("barButton: info post presented in map view")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let infoPostViewController = mainStoryboard.instantiateViewControllerWithIdentifier("InfoPostView") as! OTMInfoPostViewController
        infoPostViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController as! UINavigationController
        let mainViewController = rootViewController.viewControllers.first as! UITabBarController
        
        mainViewController.presentViewController(infoPostViewController, animated: true, completion: nil)
    }
    
    func barButtonShowLogin() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView") as! OTMLoginViewController
            loginView.delegate = self
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let rootViewController = appDelegate.window?.rootViewController as! UINavigationController
            rootViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            rootViewController.setViewControllers([loginView], animated: true)
        })
        println("bar button show login")
    }
    
}
