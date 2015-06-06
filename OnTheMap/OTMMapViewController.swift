//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import MapKit

class OTMMapViewController: UIViewController, LoginViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
        OTMClient.sharedInstance().setupNavigationItem(self.navigationItem)
        
        // listen for notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStudentLocations", name: OTMClient.Constants.NotificationReload, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loggedOut", name: OTMClient.Constants.NotificationLoggedOut, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showInfoPost:", name: OTMClient.Constants.NotificationShowInfoPost, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.login()
    }
    
    deinit {
        // stop listening to notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationReload, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationLoggedOut, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationShowInfoPost, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func didLoggedIn(status: Bool) {
        // if we are logged in, load the student locations
        if status {
            self.loadStudentLocations()
        } else {
            println("not logged in, don't get student locations")
        }
    }
    
    func login() -> Void {
        
        // login if there's no session id
        if let session = OTMClient.sharedInstance().sessionID {
            println("didFinish session: \(session)")
        } else {
            println("didFinish no session, login")
            
            let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! OTMLoginViewController
            loginView.delegate = self
            self.presentViewController(loginView, animated: false, completion: nil)
        }
    }
    
    func loggedOut() -> Void {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationItem.leftBarButtonItem?.enabled = false
        })
    }
    
    func showInfoPost(sender: AnyObject) {
        println("map view SENDER: \(sender)")
        
        let infoPostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InfoPostView") as! OTMInfoPostViewController
        infoPostViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(infoPostViewController, animated: true, completion: nil)
    }
    
    func updateStudentLocations() {
        
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
        
        OTMClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            
//            println("student locations \(result)")
            if let result = result {
                // got the student locations
//                println("got student locations \(result)")
                
//                for student in result {
//                    println("** Object \(student)")
//                    let studentObject = OTMStudentLocations.parseJSON(student)
//                    println("* name: \(studentObject.studentName) url: \(studentObject.studentLink) coordinate: \(studentObject.coordinate)")
//                    OTMClient.sharedInstance().studentLocations.append(studentObject)
//
//                }
                
                self.updateStudentLocations()
                
            } else {
                // couldn't get the student locations
                println("didn't get student locations \(error)")
            }
        }
    }


}

