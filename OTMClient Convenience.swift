//
//  OTMClient Convenience.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/20/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

extension OTMClient {
    
    func authorizeUser(username: String, password: String, completionHandlerForAuthorization: (success: Bool, error: NSError?)->Void) {
        
        getSessionID(username, password: password) {
            (success, result, error) in
            
            if let error = error {
                completionHandlerForAuthorization(success: false, error: error)
            } else {
                if success {
                    self.sessionID = result as? String
                    completionHandlerForAuthorization(success: true, error: nil)
                } else {
                    let error = self.getError("authorizeUser", code: 1, error: "Did not succeed in retrieving sessionID")
                    completionHandlerForAuthorization(success: false, error: error)
                }
            }
        }
        
    }
    
    func getSessionID(username: String, password: String, completionHandlerForGetSessionID: (success: Bool, result: AnyObject?, error: NSError?)-> Void) {
        
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        taskForPOSTMethod(OTMClient.Methods.UdacitySessionID, parameters: [String: AnyObject](), jsonBody: jsonBody, service: OTMClient.Service.Udacity) {
            (result, error) in
            
            if let error = error {
                completionHandlerForGetSessionID(success: false, result: nil, error: error)
            } else {
                guard let session = result[OTMClient.ResponseKeys.Session] as? [String: AnyObject] else {
                    let error = self.getError("getSessionID", code: 1, error: "Failed to access Session Dict")
                    completionHandlerForGetSessionID(success: false, result: nil, error: error)
                    return
                }
                guard let sessionID = session[OTMClient.ResponseKeys.SessionID] as? String else {
                    let error = self.getError("getSessionID", code: 1, error: "Failed retrieving Session ID")
                    completionHandlerForGetSessionID(success: false, result: nil, error: error)
                    return
                }
                completionHandlerForGetSessionID(success: true, result: sessionID, error: nil)
            }
        }
    }
    
    func getStudentLocations() {
        
    }
    
}
