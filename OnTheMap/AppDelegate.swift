//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        FBSDKLoginButton()
        
        showInitialView()

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func showInitialView() {
        // setup initial views
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
        OTMClient.sharedInstance().delegate = OTMLogin.sharedInstance()
        let rootViewController = UINavigationController(rootViewController: mainView)
        rootViewController.navigationBar.hidden = true
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()

        // if logged into facebook before, retrieve the data again
        if FBSDKAccessToken.currentAccessToken() != nil {
            let session = OTMClient.getSession()
            OTMClient.sharedInstance().sessionID = session
            
            OTMClient.sharedInstance().getPublicUserData({ (success, results, errorString) -> Void in
                if success {
                    
                    // get the student data
                    
                } else {
                    println("failed didn't get user data")
                }
            })
        }
        
        // check if there's a current session
        if let session = OTMClient.getSession() {
            OTMClient.sharedInstance().sessionID = session
            // already logged in
            println("logged in, show main")
            
            OTMClient.sharedInstance().getPublicUserData({ (success, results, errorString) -> Void in
                if success {
                    
                    // get the student data
                    
                } else {
                    println("failed didn't get user data")
                }
            })
            
            rootViewController.setViewControllers([mainView], animated: false)
            
            
        } else {
            // not logged in, show login view
            let loginView = mainStoryboard.instantiateViewControllerWithIdentifier("LoginView") as! OTMLoginViewController
            loginView.delegate = OTMLogin.sharedInstance()
            rootViewController.setViewControllers([loginView], animated: false)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

