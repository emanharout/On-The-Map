//
//  OTMClient.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/11/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class OTMClient: NSObject {
    
    var sessionID: String?
    
    private func taskForGETMethod (method: String, parameters: [String: AnyObject], completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let url = urlFromComponents("https", host: Constants.Host, method: method, parameters: parameters)
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            guard error == nil else {
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                return
            }
            guard let data = data else {
                return
            }
            
            self.parseData(data, completionHandlerForParseData: completionHandler)
        }
        task.resume()
        return task
    }
    
    private func taskForPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: String, service: Service, completionHandlerForPOST: (result: AnyObject!, error: String?)->Void) -> NSURLSessionDataTask {
        
        let url = urlFromComponents("https", host: Constants.Host, method: method, parameters: parameters)
        print("\(url)")
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            // TODO: Ask how to use errors properly
            
            func sendError(error: String) {
                print("\(error)")
                
            }
            
            guard error == nil else {
                print("Error in POST method")
                completionHandlerForPOST(result: nil, error: "\(error)")
                return
            }
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                print("Non-2xx status code for POST method \((response as? NSHTTPURLResponse)?.statusCode)")
//                return
//            }
//            print("\(statusCode)")
            
            guard let data = data else {
                print("Failure to retrieve POST method data")
                return
            }
            
            let formattedData: NSData
            if service == .Udacity {
                formattedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            } else {
                formattedData = data
            }
            
            self.parseData(formattedData, completionHandlerForParseData: completionHandlerForPOST)
        }
        
        task.resume()
        return task
    }
    
    func authorizeUser(username: String, password: String, completionHandlerForAuthorization: (success: Bool, error: String?)->Void) {
        
        getSessionID(username, password: password) {
            (success, result, error) in
            
            if let error = error {
                print("\(error)")
                completionHandlerForAuthorization(success: false, error: error)
            } else {
                if success {
                    self.sessionID = result as? String
                    completionHandlerForAuthorization(success: true, error: nil)
                } else {
                    completionHandlerForAuthorization(success: false, error: "Did not succeed in retrieving sessionID")
                }
            }
        }
        
    }
    
    private func getSessionID(username: String, password: String, completionHandlerForGetSessionID: (success: Bool, result: AnyObject?, error: String?)-> Void) {
        
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        taskForPOSTMethod(OTMClient.Methods.UdacitySessionID, parameters: [String: AnyObject](), jsonBody: jsonBody, service: OTMClient.Service.Udacity) {
            (result, error) in
            
            if let error = error {
                completionHandlerForGetSessionID(success: false, result: nil, error: error)
            } else {
                guard let session = result[OTMClient.ResponseKeys.Session] as? [String: AnyObject] else {
                    completionHandlerForGetSessionID(success: false, result: nil, error: "Failed to access Session Dict")
                    return
                }
                guard let sessionID = session[OTMClient.ResponseKeys.SessionID] as? String else {
                    completionHandlerForGetSessionID(success: false, result: nil, error: "Failed to retrieve Session ID")
                    return
                }
                completionHandlerForGetSessionID(success: true, result: sessionID, error: nil)
            }
            
        }
    }
    
    private func parseData(data: NSData, completionHandlerForParseData: (result: AnyObject!, error: String?)-> Void) {
        
        let parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print("Parsed Data: \(parsedResult)")
        } catch {
            completionHandlerForParseData(result: nil, error: "Failed to Parse Data")
            return
        }
        
        completionHandlerForParseData(result: parsedResult, error: nil)
    }
    
    private func urlFromComponents(scheme: String, host: String, method: String, parameters: [String: AnyObject]) -> NSURL {
        let url = NSURLComponents()
        url.scheme = scheme
        url.host = host
        url.path = method
        url.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let query = NSURLQueryItem(name: key, value: "\(value)")
            url.queryItems?.append(query)
        }
        
        return url.URL!
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedSession = OTMClient()
        }
        return Singleton.sharedSession
    }
}
