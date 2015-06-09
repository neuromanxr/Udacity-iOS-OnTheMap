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

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}
