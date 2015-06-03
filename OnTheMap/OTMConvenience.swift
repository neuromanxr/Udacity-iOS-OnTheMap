//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import Foundation

extension OTMClient {
    
    // MARK: - AUTH - then get the user data
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // get the session id first
        self.getSessionID { (success, sessionID, errorString) -> Void in
            if success {
                self.sessionID = sessionID
                println("auth session id \(self.sessionID)")
                // then get the user data using the session id (user_id)
                self.getPublicUserData({ (success, result, errorString) -> Void in
                    if success {
                        println("success got user data \(result)")
                        completionHandler(success: success, errorString: errorString)
                    } else {
                        completionHandler(success: success, errorString: errorString)
                    }
                })
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    // MARK: - DELETE - logout of session
    func logoutOfSession(hostViewController: UIViewController, completionHandler: (result: [String: AnyObject]?, error: NSError?) -> Void) {
        
        let urlString = Constants.UdacityBaseURL + Methods.AuthenticationSessionNew
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                let newError = OTMClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                println("DELETE logout \(response)")
            }
        })
        task.resume()
    }
    
    // MARK: - GET
    
    // MARK: -PARSE - get the student locations from Parse
    func getStudentLocations(completionHandler: (result: [[String: AnyObject]]?, error: NSError?) -> Void) {
        // specify parameters
        // set the max student locations to 100
        let parameters = [OTMClient.ParameterKeys.MaxStudentLocations: OTMClient.Constants.MaxStudentLocationsValue]
        // set the header field for Parse
        let requestValues: [String: String] = [
            HeaderFieldKeys.HeaderFieldParseAppID: Constants.ParseAppID,
            HeaderFieldKeys.HeaderFieldParseAPIKey: Constants.ParseAPIKey]
        
        // make the request
        taskForGETMethod(Constants.ParseBaseURL, method: Methods.StudentLocations, parameters: parameters, requestValues: requestValues) { (result, error) -> Void in
            if let error = error {
                // there was an error in the request
                println("GET student locations: didn't get the json")
                completionHandler(result: nil, error: error)
            } else {
                // got the json result
                println("GET student locations: got the json")
                if let results = result.valueForKey(JSONResponseKeys.Results) as? [[String: AnyObject]] {
                    // parsed the json result
                    completionHandler(result: results, error: nil)
                    println("student locations: got the result \(results)")
                } else {
                    // couldn't parse the json result
                    println("GET student locations: couldn't parse results")
                    completionHandler(result: nil, error: NSError(domain: "student locations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't parse student locations"]))
                }
            }
        }
    }
    
    // MARK: -PARSE - query for student location
    func queryStudentLocation(completionHandler: (success: Bool, result: [String: AnyObject]?, errorString: String?) -> Void) {
        
        // query parameter
        var parameters: [String: String] = ["where": "string"]
        
        // for the header fields
        let requestValues: [String: String] = [
            HeaderFieldKeys.HeaderFieldParseAPIKey: Constants.ParseAPIKey,
            HeaderFieldKeys.HeaderFieldParseAppID: Constants.ParseAppID
        ]
        
        // replace unique key
        var mutableMethod: String = Methods.StudentLocations
        mutableMethod = OTMClient.subtituteKeyInMethod(mutableMethod, key: "uniqueKey", value: "string")!
        
        // make the request
        taskForGETMethod(Constants.ParseBaseURL, method: mutableMethod, parameters: parameters, requestValues: requestValues) { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, result: nil, errorString: "request error: query student locations failed")
            } else {
                println("student location query response \(result)")
                if let results = result.valueForKey("results") as? [String: AnyObject] {
                    completionHandler(success: true, result: results, errorString: nil)
                } else {
                    completionHandler(success: false, result: nil, errorString: "couldn't parse result: query student location failed")
                }
            }
        }
    }
    
    // MARK: -UDACITY - get the public user data from Udacity
    func getPublicUserData(completionHandler: (success: Bool, result: [String: AnyObject]?, errorString: String?) -> Void) {
        // specify parameters
        var parameters = [String: AnyObject]()
        // there's no header field
        var requestValues = [String: String]()
        // replace user_id in url with id from new session
        var mutableMethod: String = Methods.AccountIDPublicUserData
        mutableMethod = OTMClient.subtituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: self.sessionID!)!
        
        // make the request
        taskForGETMethod(Constants.UdacityBaseURL, method: mutableMethod, parameters: parameters, requestValues: requestValues) { (result, error) -> Void in
            if let error = error {
                // there was an error in the request
                completionHandler(success: false, result: nil, errorString: "request error: get public user data failed")
            } else {
                // got the json result
                println("user data results \(result)")
                if let results = result.valueForKey(JSONResponseKeys.User) as? [String: AnyObject] {
                    // parsed the json result
                    completionHandler(success:true, result: results, errorString: nil)
                } else {
                    // couldn't parse the json result
                    completionHandler(success: false, result: nil, errorString: "couldn't parse result: get public user data failed")
                }
            }
        }
        
    }
    
    // MARK: - PUT
    func updateStudentLocation(completionHandler: (success: Bool, result: String?, errorString: String?) -> Void) {
        
        // object id for parameter
        var parameters: [String: String] = ["objectid": "string"]
        
        // for the header fields
        var requestValues: [String: String] = [
            HeaderFieldKeys.HeaderFieldParseAppID: Constants.ParseAppID,
            HeaderFieldKeys.HeaderFieldParseAPIKey: Constants.ParseAPIKey,
            HeaderFieldKeys.HeaderFieldUdacityContentType: HeaderFieldValues.HeaderFieldUdacityValue
        ]
        
        // json body
        let jsonBody: [String: String] = ["uniqueKey": "numbers", "firstName": "string", "lastName": "string", "mapString": "string", "mediaURL": "string", "latitude": "float", "longitude": "float"]
        
        // make the request
        taskForPUTMethod(Constants.ParseBaseURL, method: Methods.StudentLocations, parameters: parameters, requestValues: requestValues, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, result: nil, errorString: "request error: update student location failed")
            } else {
                println("results \(result)")
                if let results = result.valueForKey("updatedAt") as? String {
                    println("update at \(results)")
                    completionHandler(success: true, result: results, errorString: nil)
                } else {
                    completionHandler(success: false, result: nil, errorString: "parse error: update student location failed")
                }
            }
        }
    }
    
    // MARK: - POST
    
    // MARK: -FACEBOOK - create new session via Facebook
    func getFacebookSessionID(completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        // no parameters
        var parameters = [String: AnyObject]()
        
        // for the header fields
        var requestValues: [String: String] = [
            HeaderFieldKeys.HeaderFieldUdacityAccept: HeaderFieldValues.HeaderFieldUdacityValue,
            HeaderFieldKeys.HeaderFieldUdacityContentType: HeaderFieldValues.HeaderFieldUdacityValue
        ]
        
        // json body with Facebook access token
        var accessToken: [String: String] = ["access_token": "string"]
        let jsonBody: [String: AnyObject] = ["facebook_mobile": accessToken]
        
        // make the request
        taskForPOSTMethod(Constants.UdacityBaseURL, method: Methods.AuthenticationSessionNew, parameters: parameters, requestValues: requestValues, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, sessionID: nil, errorString: "login failed (facebook session id)")
            } else {
                if let session = result.valueForKey("account")?.valueForKey("key") as? String {
                    println("session id \(session)")
                    completionHandler(success: true, sessionID: session, errorString: nil)
                } else {
                    completionHandler(success: false, sessionID: nil, errorString: "couldn't parse results. login failed (facebook session id)")
                }
            }
        }
    }
    
    // MARK: -UDACITY - create a new session
    func getSessionID(completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        // no parameters
        var parameters = [String: AnyObject]()

        // for the header fields
        var requestValues : [String: String] = [
            HeaderFieldKeys.HeaderFieldUdacityAccept: HeaderFieldValues.HeaderFieldUdacityValue,
            HeaderFieldKeys.HeaderFieldUdacityContentType: HeaderFieldValues.HeaderFieldUdacityValue]
        
        // setup the json body
        // user account, from input
        let accountDictionary : [String: String] = ["username": self.email!, "password": self.pass!]
        let jsonBody : [String: AnyObject] = ["udacity": accountDictionary]
        
        // make the request
        taskForPOSTMethod(Constants.UdacityBaseURL, method: Methods.AuthenticationSessionNew, parameters: parameters, requestValues: requestValues, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, sessionID: nil, errorString: "login failed (session id)")
            } else {
                if let session = result.valueForKey("account")?.valueForKey("key") as? String {
                    println("session id \(session)")
                    completionHandler(success: true, sessionID: session, errorString: nil)
                } else {
                    completionHandler(success: false, sessionID: nil, errorString: "couldn't parse session id")
                }
            }
        }
        
    }
    
    // MARK: -PARSE - post student location
    func postStudentLocation(completionHandler: (success: Bool, result: [String: AnyObject]?, errorString: String?) -> Void) {
        
        // no parameters
        var parameters = [String: AnyObject]()
        
        // for the header fields
        var requestValues: [String: String] = [
            HeaderFieldKeys.HeaderFieldParseAPIKey: Constants.ParseAPIKey,
            HeaderFieldKeys.HeaderFieldParseAppID: Constants.ParseAppID,
            HeaderFieldKeys.HeaderFieldUdacityContentType: HeaderFieldValues.HeaderFieldUdacityValue
        ]
        
        // json body
        let jsonBody: [String: String] = ["uniqueKey": "numbers", "firstName": "string", "lastName": "string", "mapString": "string", "mediaURL": "string", "latitude": "float", "longitude": "float"]
        
        // make the request
        taskForPOSTMethod(Constants.ParseBaseURL, method: Methods.StudentLocations, parameters: parameters, requestValues: requestValues, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(success: false, result: nil, errorString: "post student location failed")
            } else {
                if let results = result as? [String: AnyObject] {
                    let createdAt = results["createdAt"] as? String
                    println("student post created at: \(createdAt)")
                    completionHandler(success: true, result: results, errorString: nil)
                } else {
                    println("couldn't parse results (student post)")
                    completionHandler(success: false, result: nil, errorString: "couldn't parse results (student post)")
                }
            }
        }
        
    }
}
