//
//  OTMStudentInformation.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/2/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import MapKit

struct OTMStudentInformation {
    
    var studentName: String
    var studentLink: String
    var coordinate: CLLocationCoordinate2D
    
    init(dictionary: [String: AnyObject]) {
        let firstName = dictionary["firstName"] as! String
        let lastName = dictionary["lastName"] as! String
        
        self.studentName = "\(firstName) \(lastName)"
        self.studentLink = dictionary["mediaURL"] as! String
        
        let latitude = dictionary["latitude"] as! Double
        let longitude = dictionary["longitude"] as! Double
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
    static func studentFromResults(results: [[String : AnyObject]]) -> [OTMStudentInformation] {
        var students = [OTMStudentInformation]()
        
        for student in results {
            students.append(OTMStudentInformation(dictionary: student))
        }
        
        return students
    }
}
