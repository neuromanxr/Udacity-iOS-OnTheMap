//
//  OTMAlerts.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/4/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

extension OTMClient {
    
    func alertControllerWithTitle(title: String?, message: String?,actionTitle: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: actionTitle!, style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
    }
   
}
