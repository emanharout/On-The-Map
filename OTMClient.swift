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
    
    func taskForPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: String?)->Void) -> NSURLSessionDataTask {
        
        let url = urlFromComponents("https", host: Constants.Host, method: method, parameters: parameters)
        print("\(url)")
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            guard error == nil else {
                print("Error in POST method")
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Non-2xx status code for POST method \((response as? NSHTTPURLResponse)?.statusCode)")
                return
            }
            guard let data = data else {
                print("Failure to retrieve POST method data")
                return
            }
            
            self.parseData(data, completionHandlerForParseData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }
    
    func authorizeUser(username: String, password: String, completionHandlerForAuthorization: ()->Void) {
        
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        print("\(jsonBody)")
        
        taskForPOSTMethod(OTMClient.Methods.UdacitySessionID, parameters: [String: AnyObject](), jsonBody: jsonBody) {
            (result, error) in
            
            if let error = error {
                print("\(error)")
            } else {
                if let result = result {
                    print("Got results in POST method")
                    guard let session = result[OTMClient.ResponseKeys.Session] as? [String: AnyObject] else {
                        return
                    }
                    guard let sessionID = session[OTMClient.ResponseKeys.SessionID] as? String else {
                        return
                    }
                    self.sessionID = sessionID
                    print("SESSION ID RETRIEVED")
                }
            }
        }
        
    }
    
    
    
    private func parseData(data: NSData, completionHandlerForParseData: (result: AnyObject!, error: String?)-> Void) {
        let result: AnyObject?
        
        do {
            result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print("Successful ParseData")
        } catch {
            completionHandlerForParseData(result: nil, error: "Failed to Parse Data")
            return
        }
        
        completionHandlerForParseData(result: result, error: nil)
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


//{"udacity": {""username": "emmanuoel.h@gmail.com", "password": "C;4ZPu=fJ3Px)rV6M$t7"}}
//
//{\"udacity\": {\"username\": \"emmanuoel.h@gmail.com\", \"password\": \"C;4ZPu=fJ3Px)rV6M$t7\"}}
//let jsonBody = "{\"\(TMDBClient.JSONBodyKeys.MediaType)\": \"movie\",\"\(TMDBClient.JSONBodyKeys.MediaID)\": \"\(movie.id)\",\"\(TMDBClient.JSONBodyKeys.Favorite)\": \(favorite)}"
//
//let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
//print("\(jsonBody)")





