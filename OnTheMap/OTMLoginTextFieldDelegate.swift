//
//  OTMLoginTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/1/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

enum textFieldType: Int {
    case email
    case password
}

class OTMLoginTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        //
        if textField.tag == textFieldType.email.rawValue {
            println("character from email")
            
            // the text currently in the textfield
            let text = textField.text as String!
            
            if isValidEmail(text) {
                
                OTMClient.sharedInstance().email = text
                println("valid email \(OTMClient.sharedInstance().email)")
                
            } else {
                println("invalid email")
            }
        }
        
        if textField.tag == textFieldType.password.rawValue {
            println("character from password")
            
            let text = textField.text as String!
            
            OTMClient.sharedInstance().pass = text
            println("pass \(OTMClient.sharedInstance().pass)")
        }
        
    }
    
    func isValidEmail(text: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluateWithObject(text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
