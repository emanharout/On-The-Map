//
//  UdacityClient Convenience.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/20/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authorizeUser(username: String, password: String, completionHandlerForAuthorization: (success: Bool, error: NSError?)->Void) {
        
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        taskForPOSTMethod(UdacityClient.Methods.UdacitySessionID, parameters: [String: AnyObject](), jsonBody: jsonBody) {
            (result, error) in
            
            var sessionIDSuccess: Bool!
            var sessionIDError: NSError!
            var accountKeySuccess: Bool!
            var accountKeyError: NSError!
            
            if let error = error {
                completionHandlerForAuthorization(success: false, error: error)
            } else {
                
                self.getSessionID(result, error: error){
                    (success, result, error) in
                    
                    if success {
                        self.sessionID = result as? String
                        sessionIDSuccess = true
                        sessionIDError = nil
                    } else if let error = error {
                        sessionIDError = error
                    }
                }
                self.getAccountKey(result, error: error) {
                    (success, result, error) in
                    
                    if success {
                        self.accountKey = result as? String
                        accountKeySuccess = true
                        accountKeyError = nil
                    } else if let error = error {
                        accountKeyError = error
                    }
                }
                switch (sessionIDSuccess, accountKeySuccess) {
                case (true, true):
                    completionHandlerForAuthorization(success: true, error: nil)
                case (true, false):
                    completionHandlerForAuthorization(success: false, error: sessionIDError)
                case (false, true):
                    completionHandlerForAuthorization(success: false, error: accountKeyError)
                default:
                    completionHandlerForAuthorization(success: false, error: self.getError("getSessionID & getAccountKey", code: 1, error: "Failed retrieving both Account Key and Session ID"))
                }                
            }
            
            self.getAccountKey(result, error: error) {
                (success, result, error) in
                
                if let error = error {
                    completionHandlerForAuthorization(success: false, error: error)
                } else {
                    if success {
                        self.accountKey = result as? String
                    }
                }
            }
        }
    }
    
    func getAccountKey(result: AnyObject!, error: NSError?, completionHandlerForAccountKey: (success: Bool, result: AnyObject?, error: NSError?)->Void) {
        
        if let error = error {
            completionHandlerForAccountKey(success: false, result: nil, error: error)
        } else {
            guard let account = result["account"] as? NSDictionary else {
                let error = self.getError("getAccountKey", code: 1, error: "Failed to access Account Dict")
                completionHandlerForAccountKey(success: false, result: nil, error: error)
                return
            }
            guard let accountKey = account["key"] as? String else {
                let error = self.getError("getAccountKey", code: 1, error: "Failed to access Account Key in Dict")
                completionHandlerForAccountKey(success: false, result: nil, error: error)
                return
            }
            completionHandlerForAccountKey(success: true, result: accountKey, error: nil)
        }
    }
    
    func getSessionID(result: AnyObject!, error: NSError?, completionHandlerForGetSessionID: (success: Bool, result: AnyObject?, error: NSError?)-> Void) {
        
            if let error = error {
                completionHandlerForGetSessionID(success: false, result: nil, error: error)
            } else {
                guard let session = result[UdacityClient.ResponseKeys.Session] as? [String: AnyObject] else {
                    let error = self.getError("getSessionID", code: 1, error: "Failed to access Session Dict")
                    completionHandlerForGetSessionID(success: false, result: nil, error: error)
                    return
                }
                guard let sessionID = session[UdacityClient.ResponseKeys.SessionID] as? String else {
                    let error = self.getError("getSessionID", code: 1, error: "Failed retrieving Session ID")
                    completionHandlerForGetSessionID(success: false, result: nil, error: error)
                    return
                }
                completionHandlerForGetSessionID(success: true, result: sessionID, error: nil)
            }
    }
    
}
