//
//  OTMActivityIndicator.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/9/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMActivityIndicator: NSObject {
    
    var activity: UIActivityIndicatorView
    
    override init() {
        
        self.activity = UIActivityIndicatorView()
        
        super.init()
    }
    
    class func sharedInstance() -> OTMActivityIndicator {
        
        struct Singleton {
            static var sharedInstance = OTMActivityIndicator()
        }
        return Singleton.sharedInstance
    }
   
    func showActivityIndicator(parentView: UIView) {
        
        var loadingView = UIView(frame: CGRectMake(parentView.frame.width / 2, parentView.frame.height / 2, 80, 80))
        loadingView.center = parentView.center
        loadingView.backgroundColor = UIColor.orangeColor()
        loadingView.alpha = 0.5
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        self.activity.frame = CGRectMake(parentView.frame.width / 2, parentView.frame.height / 2, 40.0, 40.0)
        self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.activity.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
        self.activity.alpha = 1.0
        
        loadingView.addSubview(self.activity)
        parentView.addSubview(loadingView)
        self.activity.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.activity.stopAnimating()
        self.activity.alpha = 0.0
        self.activity.superview?.removeFromSuperview()
    }
}
