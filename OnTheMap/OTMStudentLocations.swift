//
//  OTMStudentLocations.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/2/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import MapKit

class OTMStudentLocations: NSObject, MKAnnotation {
    
    let title: String
    let studentName: String
    let studentLink: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, studentName: String, studentLink: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.studentName = studentName
        self.studentLink = studentLink
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return self.studentLink
    }
    
    class func parseJSON(results: [String: AnyObject]) -> OTMStudentLocations {
        let firstName = results["firstName"] as! String
        let lastName = results["lastName"] as! String
        
        let studentName = "\(firstName) \(lastName)"
        let title = studentName
        let studentLink = results["mediaURL"] as! String
        
        let latitude = results["latitude"] as! Double
        let longitude = results["longitude"] as! Double
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        return OTMStudentLocations(title: title, studentName: studentName, studentLink: studentLink, coordinate: coordinate)
    }
   
}
