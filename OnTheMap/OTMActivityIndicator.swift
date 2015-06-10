//
//  OTMActivityIndicator.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 6/9/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMActivityIndicator: NSObject {
   
    func showActivityIndicator(indicator: UIView) {
        var container: UIView = UIView()
        container.frame = indicator.frame
        container.center = indicator.center
        container.backgroundColor = UIColor.redColor()
        
        var loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = indicator.center
        loadingView.backgroundColor = UIColor.blueColor()
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        var activity: UIActivityIndicatorView = UIActivityIndicatorView()
        activity.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activity.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
        loadingView.addSubview(activity)
        indicator.addSubview(container)
        activity.startAnimating()
    }
}
