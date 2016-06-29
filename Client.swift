//
//  Client.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/21/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class Client: NSObject {
    
    func parseData(data: NSData, completionHandlerForParseData: (result: AnyObject!, error: NSError?)-> Void) {
        
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
    
    func urlFromComponents(scheme: String, host: String, path: String, parameters: [String: AnyObject]) -> NSURL {
        let url = NSURLComponents()
        url.scheme = scheme
        url.host = host
        url.path = path
        url.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let query = NSURLQueryItem(name: key, value: "\(value)")
            url.queryItems?.append(query)
        }
        print("URL: \(url.URL!)")
        return url.URL!
    }
    
    func getError(domain: String, code: Int, error: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: error]
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
    
    func substituteKeyInMethod(method: String, key: String, value: String) -> String? {

        if method.rangeOfString("{\(key)}") != nil {
            let updatedMethod = method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
            print("UPDATED METHOD: \(updatedMethod)")
            return updatedMethod
        } else {
            print("Return: NIL")
            return nil
        }
    }
    
    
    
}
