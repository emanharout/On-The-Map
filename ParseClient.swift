
import Foundation

class ParseClient: Client {

    static let sharedInstance = ParseClient()

    //Creates new objects, pass in object values into HTTPBody
    func taskForPOSTMethod(scheme: String, host: String, path: String, parameters: [String: AnyObject], student: StudentInformation, completionHandlerForPOSTTask: (result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionTask {

        let url = urlFromComponents(scheme, host: host, path: path, parameters: parameters)

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.HTTPBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(student.uniqueKey)\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(student.firstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(student.lastName)\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"\(student.mapString)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(student.mediaURL)\",\"\(ParseClient.JSONBodyKeys.Latitude)\": \(student.latitude), \"\(ParseClient.JSONBodyKeys.Longitude)\": \(student.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in

            guard error == nil else {
                completionHandlerForPOSTTask(result: nil, error: error)
                return
            }

            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let error = self.getError("Parse Client: taskForPOSTMethod", code: 12, error: "Status Code is not 2xx")
                print("\((response as? NSHTTPURLResponse)?.statusCode)")
                completionHandlerForPOSTTask(result: nil, error: error)
                return
            }

            guard let data = data else {
                let error = self.getError("Parse Client: taskForPOSTMethod", code: 12, error: "Error retrieving data")
                completionHandlerForPOSTTask(result: nil, error: error)
                return
            }

            self.parseData(data, completionHandlerForParseData: completionHandlerForPOSTTask)

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
    
    private override init() {
    }
}
