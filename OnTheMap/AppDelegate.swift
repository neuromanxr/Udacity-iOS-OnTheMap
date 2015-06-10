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
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerDelegate {

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
    
    func didLoggedIn(status: Bool) {
        println("logged in")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
            let rootViewController = self.window?.rootViewController as! UINavigationController
            rootViewController.setViewControllers([mainView], animated: true)
        })
    }
    
    func showInitialView() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
        OTMClient.sharedInstance().delegate = OTMLogin.sharedInstance()
        let rootViewController = UINavigationController(rootViewController: mainView)
        self.window?.rootViewController = rootViewController
        
        if OTMClient.sharedInstance().sessionID != nil {
            // already logged in
            rootViewController.setViewControllers([mainView], animated: true)
            
        } else {
            // show login
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

