//
//  OTMStudentAnnotation.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/10/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import MapKit

class OTMStudentAnnotation: NSObject, MKAnnotation {
    
    var title: String
    var studentName: String
    var studentLink: String
    var coordinate: CLLocationCoordinate2D
    
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
    
    class func annotationsFromStudents(students: [OTMStudentInformation]) -> [OTMStudentAnnotation] {
        
        var annotations = [OTMStudentAnnotation]()
        
        for student in students {
            let aTitle = student.studentName
            let aStudentName = student.studentName
            let aStudentLink = student.studentLink
            let aStudentCoordinate = student.coordinate
            
            let annotation = OTMStudentAnnotation(title: aTitle, studentName: aStudentName, studentLink: aStudentLink, coordinate: aStudentCoordinate)
            
            annotations.append(annotation)
        }
        return annotations
    }
   
}
