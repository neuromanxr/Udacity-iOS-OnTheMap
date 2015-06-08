//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

extension OTMClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: App IDs
        static let FacebookAppID: String = "365362206864879"
        static let ParseAppID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: API key
        static let ParseAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Urls
        static let ParseBaseURL: String = "https://api.parse.com/1/classes/"
        static let UdacityBaseURL: String = "https://www.udacity.com/api/"
        
        // MARK: Max Student Locations
        static let MaxStudentLocationsValue = 100
        
        // MARK: Notifications
        static let NotificationReload: String = "Reload"
        static let NotificationLoggedOut: String = "LoggedOut"
        static let NotificationShowInfoPost: String = "InfoPost"
        static let NotificationFacebookLoggedIn: String = "FacebookDidLogin"
        static let NotificationLoggedIn: String = "LoggedIn"
        static let NotificationLoadStudents: String = "LoadStudents"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Authentication
        static let AuthenticationSessionNew = "session"
        
        // MARK: Account
        static let AccountIDPublicUserData = "users/{user_id}"
        
        // MARK: Student Locations
        static let StudentLocations = "StudentLocation"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let MaxStudentLocations = "limit"
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "user_id"
        
    }
    
    // MARK: Header Field Keys
    struct HeaderFieldKeys {
        
        // MARK: Parse header fields
        static let HeaderFieldParseAppID = "X-Parse-Application-Id"
        static let HeaderFieldParseAPIKey = "X-Parse-REST-API-Key"
        
        // MARK: Udacity header fields
        static let HeaderFieldUdacityAccept = "Accept"
        static let HeaderFieldUdacityContentType = "Content-Type"
    }
    
    // MARK: Header Field Values
    struct HeaderFieldValues {
        
        // MARK: Udacity header values
        static let HeaderFieldUdacityValue = "application/json"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let SessionID = "session"
        
        // MARK: Account
        static let User = "user"
        
        // MARK: Results
        static let Results = "results"
        
    }
}
