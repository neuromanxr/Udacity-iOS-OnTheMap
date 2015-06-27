//
//  OTMInfoPostTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/27/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

extension OTMInfoPostViewController: UITextFieldDelegate {
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y -= self.getKeyboardHeight(notification) / 1.2
        
    }
    
    func keyboardWillHide(notification: NSNotification) {

        self.view.frame.origin.y += self.getKeyboardHeight(notification) / 1.2
        
    }
    
    func dismissAnyVisibleKeyboards() {
        if linkTextField.isFirstResponder() || locationTextField.isFirstResponder() {
            self.view.endEditing(true)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
   
}
