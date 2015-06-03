//
//  OTMMapViewDelegate.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/2/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import MapKit
import UIKit

extension OTMMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? OTMStudentLocations {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let studentObject = view.annotation as? OTMStudentLocations
        println("student url \(studentObject?.studentLink)")
        let studentURL = NSURL(string: studentObject?.studentLink as String!)
        UIApplication.sharedApplication().openURL(studentURL!)
    }
}
