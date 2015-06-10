//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit

class OTMMapViewController: UIViewController /*LoginViewControllerDelegate*/ {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
//        OTMClient.sharedInstance().delegate = self
        
        OTMClient.sharedInstance().setupNavigationItem(self.navigationItem)
        
        self.loadStudentLocations()
        
        
        // listen for notifications
        // load initial student data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadStudentLocations", name: OTMClient.Constants.NotificationLoadStudents, object: nil)
        // reload student data after reload button tap
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadStudentLocations", name: OTMClient.Constants.NotificationReload, object: nil)
        // user logged out
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loggedOut", name: OTMClient.Constants.NotificationLoggedOut, object: nil)
        // user logged in
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loggedIn", name: OTMClient.Constants.NotificationLoggedIn, object: nil)
        // show alert when trying to post when not logged in
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "infoPostAlert", name: OTMClient.Constants.NotificationInfoPostAlert, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.login()
    }
    
    deinit {
        // stop listening to notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationLoadStudents, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationReload, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationLoggedOut, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationLoggedIn, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationInfoPostAlert, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func barButtonShowLogin() {
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! OTMLoginViewController
////            loginView.delegate = self
//            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            let rootViewController = appDelegate.window?.rootViewController as! UINavigationController
//            rootViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
//            rootViewController.setViewControllers([loginView], animated: true)
//        })
//        println("bar button show login")
//    }
    
//    func barButtonShowInfoPost() {
//        println("barButton: info post presented in map view")
//        let infoPostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InfoPostView") as! OTMInfoPostViewController
//        infoPostViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
//        // getting a 'Presenting view controller on a detached view controllers is discouraged' without presenting from rootViewController
//        self.view.window!.rootViewController!.presentViewController(infoPostViewController, animated: true, completion: nil)
//    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
//    func didLoggedIn(status: Bool) {
//        println("logged in")
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("MainView") as! UITabBarController
//            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            let rootViewController = appDelegate.window?.rootViewController as! UINavigationController
//            rootViewController.setViewControllers([mainView], animated: true)
//        })
//    }
    
    func login() -> Void {
        
        // login if there's no session id
        if OTMClient.sharedInstance().sessionID != nil || FBSDKAccessToken.currentAccessToken() != nil {
            
            println("didFinish session: \(OTMClient.sharedInstance().sessionID), \(FBSDKAccessToken.currentAccessToken()?.tokenString)")
        } else {
            println("didFinish no session, login")
            
            let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! OTMLoginViewController
            
            self.presentViewController(loginView, animated: false, completion: nil)
        }
    }
    
    func loggedOut() -> Void {
        // logged out, change the button to login
        println("barButton: logged out in map view")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in

            OTMClient.sharedInstance().swapLeftBarButton(barButtonType.login, item: self.navigationItem)
        })
    }
    
    func loggedIn() -> Void {
        // logged in, change the button to logout
        println("barButton: logged out in map view")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in

            OTMClient.sharedInstance().swapLeftBarButton(barButtonType.logout, item: self.navigationItem)
        })
    }
    
    func infoPostAlert() {
        let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Post Info", message: "Login before you post!", actionTitle: "OK")
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addStudentAnnotations() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // update UI
            println("updated the ui")
            
            // does existing annotations need to be cleared before reloading?
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            self.mapView.addAnnotations(OTMClient.sharedInstance().studentLocations)
            
            println("annotations \(self.mapView.annotations.count)")
        })
    }
    
    func loadStudentLocations() -> Void {
        println("loading student data")
        OTMClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            
            if let result = result {
                // got the student locations
                println("got student locations")
                
                self.addStudentAnnotations()
                
            } else {
                // couldn't get the student locations
                println("didn't get student locations \(error)")
                let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Student Information", message: "Didn't get the student info", actionTitle: "OK")
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }


}

