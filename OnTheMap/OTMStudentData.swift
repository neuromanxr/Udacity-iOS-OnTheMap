//
//  OTMStudentData.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/10/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import MapKit

class OTMStudentData: NSObject {
    
    var studentObjects: [OTMStudentInformation]?
    
    var studentPost: OTMStudentPost?
    
    override init() {

        super.init()
    }
    
    class func sharedInstance() -> OTMStudentData {
        
        struct Singleton {
            static var sharedInstance = OTMStudentData()
            
        }
        return Singleton.sharedInstance
    }
   
}
