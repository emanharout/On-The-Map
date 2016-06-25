//
//  ParseClient.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/21/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class ParseClient: Client {
    
    static let sharedInstance = ParseClient()
    
    //Creates new objects, pass in object values into HTTPBody
    func taskForPOSTMethod(scheme: String, host: String, path: String, parameters: [String: AnyObject], completionHandlerForPOSTTask: (result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionTask {
        
        let url = urlFromComponents(scheme, host: host, path: path, parameters: parameters)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance.accountKey)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            guard error == nil else {
                completionHandlerForPOSTTask(result: nil, error: error)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let error = self.getError("Parse Client: taskForPOSTMethod", code: 11, error: "Status Code is not 2xx")
                completionHandlerForPOSTTask(result: nil, error: error)
                return
            }
        }
        task.resume()
        return task
    }

    
    func taskForGETMethod(scheme: String, host: String, path: String, parameters: [String: AnyObject], completionHandlerForGETTask: (result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionTask {
            
            let url = urlFromComponents(scheme, host: host, path: path, parameters: parameters)
            
            let request = NSMutableURLRequest(URL: url)
            request.addValue(ParseClient.Constants.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParseClient.Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data, response, error) in
                
                guard error == nil else {
                    completionHandlerForGETTask(result: nil, error: error)
                    return
                }
                
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    let error = self.getError("Parse Client: taskForGETMethod", code: 11, error: "Status Code is not 2xx")
                    completionHandlerForGETTask(result: nil, error: error)
                    return
                }
                
                guard let data = data else {
                    let error = self.getError("Parse Client: taskForGETMethod", code: 11, error: "Error retrieving data")
                    completionHandlerForGETTask(result: nil, error: error)
                    return
                }
                
                self.parseData(data, completionHandlerForParseData: completionHandlerForGETTask)
            }
            task.resume()
            return task
    }

        
}
