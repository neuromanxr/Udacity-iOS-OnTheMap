//
//  OTMInfoPostViewController.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/4/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import MapKit

class OTMInfoPostViewController: UIViewController {
    // 51, 102, 153
    let color = UIColor(red: 51.0/255, green: 102.0/255, blue: 153.0/255, alpha: 1.0)
    
    @IBOutlet weak var topBarView: UIView!
    // study prompt
    @IBOutlet weak var topBarLabel: UILabel!
    @IBOutlet weak var topBarLabelBold: UILabel!
    @IBOutlet weak var topBarLabelQuestion: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var topBarCancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var bottomBarButton: UIButton!
    @IBOutlet weak var middleBarView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    var activity = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
        
        removeKeyboardDismissRecognizer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.linkTextField.attributedPlaceholder = NSAttributedString(string: "Enter link", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        self.locationTextField.attributedPlaceholder = NSAttributedString(string: "Enter location (New York)", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        
        self.submitButton.layer.cornerRadius = 5.0
        self.bottomBarButton.layer.cornerRadius = 5.0
        
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func bottomBarButtonAction(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {
            // find on the map and then submit to geocode
            if !locationTextField.text.isEmpty {
                // show the activity indicator
                if !activity.isAnimating() {
                    
                    OTMActivityIndicator.sharedInstance().showActivityIndicator(self.middleBarView, activity: activity)
                }
                
                // get the geocode
                getLocationFromString(locationTextField.text, withCompletion: { (location, error) -> () in
                    if let error = error {
                        println("error \(error)")
                        // hide the activity indicator
                        OTMActivityIndicator.sharedInstance().hideActivityIndicator(self.activity)
                        
                        // location not found, show error alert
                        let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Location Error", message: "Timedout, couldn't get location", actionTitle: "OK")
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        println("location coordinates \(location)")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            // hide the activity indicator
                            OTMActivityIndicator.sharedInstance().hideActivityIndicator(self.activity)
                            // center the map on your location
                            self.centerMapOnLocation(location!)
                            self.revealMap()
                        })
                    }
                })
                
            } else {
                
                let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Location", message: "Enter a location! (Mountain View, CA)", actionTitle: "OK")
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Location", message: "No Internet!", actionTitle: "OK")
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func submitPost(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {
            // check for empty text field
            if self.linkTextField.text.isEmpty {
                // show an alert if there's no text
                let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Submit Post", message: "Enter a link!", actionTitle: "OK")
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                
                // TODO: set the studentPostObject here
                OTMStudentData.sharedInstance().studentPost?.yourLink = self.linkTextField.text
                OTMStudentData.sharedInstance().studentPost?.yourUniqueKey = "8888"
                
                if !activity.isAnimating() {
                    OTMActivityIndicator.sharedInstance().showActivityIndicator(self.view, activity: activity)
                }
                OTMClient.sharedInstance().postStudentLocation({ (success, result, errorString) -> Void in
                    if success {
                        println("posting the link: \(result)")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            // hide the activity indicator
                            OTMActivityIndicator.sharedInstance().hideActivityIndicator(self.activity)
                            
                            let alertController = UIAlertController(title: "Success", message: "Link Posted", preferredStyle: UIAlertControllerStyle.Alert)
                            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertActionOK) -> Void in
                                // then dismiss view
                                self.dismissViewControllerAnimated(true, completion: nil)
                            })
                            alertController.addAction(alertAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                        
                        
                    } else {
                        println("error posting: \(errorString)")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            // hide the activity indicator
                            OTMActivityIndicator.sharedInstance().hideActivityIndicator(self.activity)
                            
                            let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Submit Post", message: "Post submission failed!", actionTitle: "OK")
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                    }
                })
            }
        } else {
            let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Post", message: "No Internet!", actionTitle: "OK")
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func getLocationFromString(string: String, withCompletion completion: (location: CLLocation?, error: NSError?) -> ()) {
        
        CLGeocoder().geocodeAddressString(string) { (location: [AnyObject]!, error: NSError!) -> Void in
//            println("geocode \(location)")
            if let error = error {
                println("error geocoding in function \(error)")
                completion(location: nil, error: error)

            } else {
                let placemark = location.first as! CLPlacemark
                let coordinates = placemark.location
                // set the string and coordinates
                OTMStudentData.sharedInstance().studentPost?.yourMapString = string
                OTMStudentData.sharedInstance().studentPost?.yourCoordinates = coordinates
                
                completion(location: coordinates, error: nil)
                
            }
        }
    }
    
    func revealMap() {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.topBarView.backgroundColor = self.color

            self.middleBarView.alpha = 0.0
            
            self.bottomBarButton.alpha = 0.0
            self.bottomBarView.alpha = 0.5
            self.linkTextField.alpha = 1.0
            self.submitButton.alpha = 1.0
            
            self.topBarLabel.alpha = 0.0
            self.topBarLabelBold.alpha = 0.0
            self.topBarLabelQuestion.alpha = 0.0
            self.topBarCancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
        })
        self.linkTextField.enabled = true
        self.bottomBarButton.enabled = false
        self.submitButton.enabled = true
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.001, 0.001))
        self.mapView.setRegion(region, animated: true)
        
        let myPost = OTMStudentAnnotation(title: "You", studentName: "You", studentLink: "Your link!", coordinate: location.coordinate)

        self.mapView.addAnnotation(myPost)
    }

}
