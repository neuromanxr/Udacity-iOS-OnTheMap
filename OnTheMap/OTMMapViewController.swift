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
    
    var studentLocations = [OTMStudentLocations]()
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.login()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createStudentAnnotations() -> Void {
        
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
    
    func loadStudentLocations() -> Void {
        
        OTMClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            
//            println("student locations \(result)")
            if let result = result {
                // got the student locations
//                println("got student locations \(result)")
                
                for student in result {
                    println("** Object \(student)")
                    let studentObject = OTMStudentLocations.parseJSON(student)
                    println("* name: \(studentObject.studentName) url: \(studentObject.studentLink) coordinate: \(studentObject.coordinate)")
                    self.studentLocations.append(studentObject)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // update UI
                    println("updated the ui")
                    self.mapView.addAnnotations(self.studentLocations)
                })
                
            } else {
                // couldn't get the student locations
                println("didn't get student locations \(error)")
            }
        }
    }


}

