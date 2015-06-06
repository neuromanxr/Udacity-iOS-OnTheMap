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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissInfoPostView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupNavigationBar() {
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.width, 120))
        self.view.addSubview(navigationBar)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismissInfoPostView")
        let titleLabel = UILabel(frame: CGRectMake(0, -10, navigationBar.frame.width / 2, navigationBar.frame.height))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "POST INFO"
        titleLabel.sizeToFit()
        let navigationItems = UINavigationItem(title: titleLabel.text)
        navigationItems.titleView = titleLabel
        
        navigationItems.rightBarButtonItem = cancelButton
        navigationBar.items = [navigationItems]
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func bottomBarButtonAction(sender: UIButton) {
        // find on the map and then submit to geocode
        if !locationTextField.text.isEmpty {
            // get the geocode
            getLocationFromString(locationTextField.text, withCompletion: { (location, error) -> () in
                if let error = error {
                    println("error \(error)")
                    // location not found, show error alert
                    let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Location Error", message: "Location not found", actionTitle: "OK")
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    println("location coordinates \(location)")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // center the map on your location
                        
                        self.centerMapOnLocation(location!)
                        self.revealMap()
                    })
                }
            })
            
        } else {
            
//            let alertController = UIAlertController(title: "Location", message: "Enter a location! (Mountain View, CA)", preferredStyle: UIAlertControllerStyle.Alert)
//            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
//            alertController.addAction(alertAction)
            
            let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Location", message: "Enter a location! (Mountain View, CA)", actionTitle: "OK")
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func submitPost(sender: UIButton) {
        // post
        
        // then dismiss view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getLocationFromString(string: String, withCompletion completion: (location: CLLocation?, error: NSError?) -> ()) {
        
        CLGeocoder().geocodeAddressString(string) { (location: [AnyObject]!, error: NSError!) -> Void in
//            println("geocode \(location)")
            if let error = error {
                println("error in function \(error)")
                completion(location: nil, error: error)
            } else {
                let placemark = location.first as! CLPlacemark
                let coordinates = placemark.location
                completion(location: coordinates, error: nil)
                
            }
        }
    }
    
    func revealMap() {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.topBarView.backgroundColor = UIColor.blueColor()
            self.middleBarView.alpha = 0.0
            
            self.bottomBarButton.alpha = 0.0
            self.bottomBarView.alpha = 0.5
            self.linkTextField.alpha = 1.0
            self.submitButton.alpha = 1.0
            
            self.topBarLabel.alpha = 0.0
            self.topBarLabelBold.alpha = 0.0
            self.topBarLabelQuestion.alpha = 0.0
            
        })
        self.linkTextField.enabled = true
        self.bottomBarButton.enabled = false
        self.submitButton.enabled = true
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.001, 0.001))
        self.mapView.setRegion(region, animated: true)
        
        let yourName = OTMClient.sharedInstance().yourName
        let myPost = OTMStudentLocations(title: yourName!, studentName: yourName!, studentLink: "link", coordinate: location.coordinate)
        self.mapView.addAnnotation(myPost)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
