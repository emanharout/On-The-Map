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
        objectId = studentDict["\(OTMClient.ResponseKeys.ObjectID)"] as? String
        uniqueKey = studentDict["\(OTMClient.ResponseKeys.UniqueKey)"] as? String
        firstName = studentDict["\(OTMClient.ResponseKeys.FirstName)"] as? String
        lastName = studentDict["\(OTMClient.ResponseKeys.LastName)"] as? String
        mapString = studentDict["\(OTMClient.ResponseKeys.MapString)"] as? String
        mediaURL = studentDict["\(OTMClient.ResponseKeys.MediaURL)"] as? String
        latitude = studentDict["\(OTMClient.ResponseKeys.Latitude)"] as? Float
        longitude = studentDict["\(OTMClient.ResponseKeys.Longitude)"] as? Float
    }
    
}
