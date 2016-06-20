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
    
    private func taskForGETMethod (method: String, parameters: [String: AnyObject], service: Service, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let url = urlFromComponents("https", host: Constants.Host, method: method, parameters: parameters)
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            guard error == nil else {
                completionHandlerForGET(result: nil, error: error)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let error = self.getError("taskForGETMethod", code: 1, error: "Server returned non-2xx status code")
                completionHandlerForGET(result: nil, error: error)
                return
            }
            guard let data = data else {
                let error = self.getError("taskForGETMethod", code: 1, error: "Failure to retrieve data from server")
                completionHandlerForGET(result: nil, error: error)
                return
            }
            
            let formattedData: NSData
            if service == .Udacity {
                formattedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            } else {
                formattedData = data
            }
            
            self.parseData(formattedData, completionHandlerForParseData: completionHandlerForGET)
        }
        task.resume()
        return task
    }
    
    private func taskForPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: String, service: Service, completionHandlerForPOST: (result: AnyObject!, error: NSError?)->Void) -> NSURLSessionDataTask {
        
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
                print("Error with POST request")
                completionHandlerForPOST(result: nil, error: error)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let error = self.getError("taskForPOSTMethod", code: 1, error: "Server returned non-2xx status code")
                completionHandlerForPOST(result: nil, error: error)
                return
            }
            print("\(statusCode)")
            
            guard let data = data else {
                let error = self.getError("taskForPOSTMethod", code: 1, error: "Failure to retrieve data from server")
                completionHandlerForPOST(result: nil, error: error)
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
    
    private func getSessionID(username: String, password: String, completionHandlerForGetSessionID: (success: Bool, result: AnyObject?, error: NSError?)-> Void) {
        
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
    
    private func parseData(data: NSData, completionHandlerForParseData: (result: AnyObject!, error: NSError?)-> Void) {
        
        let parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print("Parsed Data: \(parsedResult)")
        } catch {
            let error = self.getError("parseData", code: 1, error: "Failed to Parse Data")
            completionHandlerForParseData(result: nil, error: error)
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
    
    func getError(domain: String, code: Int, error: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: error]
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
    
}
