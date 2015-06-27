//
//  OTMActivityIndicator.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/9/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMActivityIndicator: NSObject {
    
    override init() {
        
        super.init()
    }
    
    class func sharedInstance() -> OTMActivityIndicator {
        
        struct Singleton {
            static var sharedInstance = OTMActivityIndicator()
        }
        return Singleton.sharedInstance
    }
   
    func showActivityIndicator(parentView: UIView, activity: UIActivityIndicatorView) {
        
        activity.startAnimating()
        
        var loadingView = UIView(frame: CGRectMake(parentView.frame.width / 2 - 40, parentView.frame.height / 2, 80, 80))
//        loadingView.center = parentView.center
        loadingView.backgroundColor = UIColor.orangeColor()
        loadingView.alpha = 0.5
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activity.frame = CGRectMake(parentView.frame.width / 2, parentView.frame.height / 2, 40.0, 40.0)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activity.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
        activity.alpha = 1.0
        
        loadingView.addSubview(activity)
        parentView.addSubview(loadingView)
        println("Parent View: \(parentView.frame.origin.x), \(parentView.frame.origin.y)")
        println("Act View: \(loadingView.frame.origin.x), \(loadingView.frame.origin.y)")
    }
    
    func hideActivityIndicator(activity: UIActivityIndicatorView) {
        
        activity.stopAnimating()
        
        activity.alpha = 0.0
        activity.superview?.removeFromSuperview()

    }
}
