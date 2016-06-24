//
//  Constants.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/11/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
    }
    
    struct Methods {
        static let UdacitySessionID = "/api/session"
    }
    
    struct ParameterKeys {
        
    }
    
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct ResponseKeys {
        static let Session = "session"
        static let SessionID = "id"
        static let Account = "account"
        static let Key = "key"
    }
}
