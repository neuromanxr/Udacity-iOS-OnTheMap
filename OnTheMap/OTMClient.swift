//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMClient: NSObject {
    
    // shared session
    var session: NSURLSession
    
    // authentication state
    var sessionID: String? = nil
    
    // initialize shared NSURL session
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - Shared Instance Singleton
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: - GET
    func taskForGETMethod(baseURL: String, method: String, parameters: [String: AnyObject], requestValues: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // set the parameters
        var mutableParameters = parameters
        
        // build url and configure request
        let urlString = baseURL + method + OTMClient.escapedParameters(mutableParameters)
        println("url string \(urlString)")
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        println("request  \(request)")
        
        if !requestValues.isEmpty {
            for (header, value) in requestValues {
                request.addValue(value as? String, forHTTPHeaderField: header)
            }
        }
        // make the request
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                // pass the error
                println("GET response: \(response)")
                completionHandler(result: nil, error: newError)
            } else {
                // skip the first 5 characters in response!
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                // use the parse json helper
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
                println("GET Request Success: \(response)")
            }
        })
        task.resume()
        
        return task
    }
    
    // MARK: - POST
    func taskForPOSTMethod(baseURL: String, method: String, parameters: [String: AnyObject], requestValues: [String: AnyObject], jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // set the parameters
        var mutableParameters = parameters
        
        // build url and configure request
        let urlString = baseURL + method + OTMClient.escapedParameters(mutableParameters)
        println("url string \(urlString)")
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        var jsonifyError: NSError? = nil
        
        // add the header fields from the dictionary
        if !requestValues.isEmpty {
            for (header, value) in requestValues {
                request.addValue(value as? String, forHTTPHeaderField: header)
            }
        }
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        // make the request
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                // pass the error
                println("POST request error \(newError)")
                completionHandler(result: nil, error: newError)
            } else {
                
                println("POST request success \(response)")
                // skip the first 5 characters in response!
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                println("POST request data \(NSString(data: newData, encoding: NSUTF8StringEncoding))")
                // use the parse json helper
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        })
        task.resume()
        
        return task
    }
    
    // MARK: - PUT
    func taskForPUTMethod(baseURL: String, method: String, parameters: [String: String], requestValues: [String: AnyObject], jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // set the parameters
        var mutableParameters = parameters
        
        // build url and configure request
        let urlString = baseURL + method + OTMClient.escapedParameters(mutableParameters)
        println("url string \(urlString)")
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        var jsonifyError: NSError? = nil
        
        // add the header fields from the dictionary
        if !requestValues.isEmpty {
            for (header, value) in requestValues {
                request.addValue(value as? String, forHTTPHeaderField: header)
            }
        }
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        // make the request
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                // pass the error
                println("PUT request error \(newError)")
                completionHandler(result: nil, error: newError)
            } else {
                
                println("PUT request success \(response)")
                // skip the first 5 characters in response!
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                println("PUT request data \(NSString(data: newData, encoding: NSUTF8StringEncoding))")
                // use the parse json helper
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        })
        task.resume()
        
        return task
    }
    
    // MARK: - Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
            
            if let errorMessage = parsedResult[OTMClient.JSONResponseKeys.StatusMessage] as? String {
                
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                
                return NSError(domain: "TMDB Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
   
}
