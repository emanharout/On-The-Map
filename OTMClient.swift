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
    
    func taskForGETMethod (method: String, parameters: [String: AnyObject], completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
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
    
    func taskForPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: String, service: Service, completionHandlerForPOST: (result: AnyObject!, error: String?)->Void) -> NSURLSessionDataTask {
        
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
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Non-2xx status code for POST method \((response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            print("\(statusCode)")
            
            guard let data = data else {
                print("Failure to retrieve POST method data")
                return
            }
            
            if service == .Udacity {
                let formattedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            } else {
                let formattedData = data
            }
            
            self.parseData(formattedData, completionHandlerForParseData: completionHandlerForPOST)
        }
        
        task.resume()
        return task
    }
    
    func authorizeUser(username: String, password: String, completionHandlerForAuthorization: (result: AnyObject!, error: String?)->Void) {
        
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        
        taskForPOSTMethod(OTMClient.Methods.UdacitySessionID, parameters: [String: AnyObject](), jsonBody: jsonBody, service: .Udacity) {
            (result, error) in
            
            print("Resulting Data after parse: \(result)")
            
            if let error = error {
                completionHandlerForAuthorization(result: nil, error: error)
            } else {
                if let result = result {
                    
                    guard let session = result[OTMClient.ResponseKeys.Session] as? [String: AnyObject] else {
                        completionHandlerForAuthorization(result: result, error: "Failed to access session dict")
                        return
                    }
                    guard let sessionID = session[OTMClient.ResponseKeys.SessionID] as? String else {
                        completionHandlerForAuthorization(result: result, error: "No session ID found in session dict")
                        return
                    }
                    self.sessionID = sessionID
                    completionHandlerForAuthorization(result: result, error: nil)
                }
            }
        }
        
    }
    
    
    
    private func parseData(data: NSData, completionHandlerForParseData: (result: AnyObject!, error: String?)-> Void) {
        
        let parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print("Successfully Parsed Data: \(parsedResult)")
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
