//
//  StudentInformation.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/11/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation


struct StudentInformation {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Float?
    var longitude: Float?
    
    static var studentArray = [StudentInformation]()
    
    init (studentDict: [String: AnyObject]) {
        objectId = studentDict["\(ParseClient.ResponseKeys.ObjectID)"] as? String
        uniqueKey = studentDict["\(ParseClient.ResponseKeys.UniqueKey)"] as? String
        firstName = studentDict["\(ParseClient.ResponseKeys.FirstName)"] as? String
        lastName = studentDict["\(ParseClient.ResponseKeys.LastName)"] as? String
        mapString = studentDict["\(ParseClient.ResponseKeys.MapString)"] as? String
        mediaURL = studentDict["\(ParseClient.ResponseKeys.MediaURL)"] as? String
        latitude = studentDict["\(ParseClient.ResponseKeys.Latitude)"] as? Float
        longitude = studentDict["\(ParseClient.ResponseKeys.Longitude)"] as? Float
    }
    
}
