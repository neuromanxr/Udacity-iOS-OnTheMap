//
//  OTMFormTextField.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/8/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

@IBDesignable

class OTMFormTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}
