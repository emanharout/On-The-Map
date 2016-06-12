//
//  OTMClient.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/11/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class OTMClient: NSObject {
    
    
    func taskForGetMethod(method: String, parameters: [String: AnyObject]) {
        
        guard let url = buildURL(Constants.Host, method: method, parameters: parameters) else {
            print("URL did not build")
            return
        }
        let request = NSMutableURLRequest(URL: url)
        
        
    }
    
    
    
    
    
    
    
    private func buildURL(host: String, method: String, parameters: [String: AnyObject]) -> NSURL? {
        let url = NSURLComponents()
        url.scheme = "https"
        url.host = host
        url.path = method
        //url.queryItems =
        
        return url.URL
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedSession = OTMClient()
        }
        return Singleton.sharedSession
    }
}
