
import Foundation

struct StudentInformation {

    var objectId: String?
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float

    init (studentDict: [String: AnyObject]) {
        objectId = studentDict["\(ParseClient.ResponseKeys.ObjectID)"] as? String
        uniqueKey = studentDict["\(ParseClient.ResponseKeys.UniqueKey)"] as! String
        firstName = studentDict["\(ParseClient.ResponseKeys.FirstName)"] as! String
        lastName = studentDict["\(ParseClient.ResponseKeys.LastName)"] as! String
        mapString = studentDict["\(ParseClient.ResponseKeys.MapString)"] as! String
        mediaURL = studentDict["\(ParseClient.ResponseKeys.MediaURL)"] as! String
        latitude = studentDict["\(ParseClient.ResponseKeys.Latitude)"] as! Float
        longitude = studentDict["\(ParseClient.ResponseKeys.Longitude)"] as! Float
    }

    init(objectId: String?, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float) {
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
