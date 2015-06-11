//
//  OTMStudentPost.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/10/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import MapKit

struct OTMStudentPost {
    
    // your info
    var yourFirstName = "First Name"
    var yourLastName = "Last Name"
    var yourCoordinates: CLLocation?
    var yourLink = "Url"
    var yourUniqueKey = "Key"
    var yourMapString = "Map String"

}

extension OTMStudentPost {
    init(firstName: String, lastName: String) {
        self.yourFirstName = firstName
        self.yourLastName = lastName
    }
}