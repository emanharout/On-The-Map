
import Foundation

class UdacityClient: Client {
    
    static let sharedInstance = UdacityClient()
    var sessionID: String?
    var accountKey: String?
    var userFirstName: String?
    var userLastName: String?

    func taskForGETMethod (method: String, parameters: [String: AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let url = urlFromComponents(Constants.Scheme, host: Constants.Host, path: method, parameters: parameters)
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

            let formattedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            self.parseData(formattedData, completionHandlerForParseData: completionHandlerForGET)
        }
        task.resume()
        return task
    }

    func taskForPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?)->Void) -> NSURLSessionDataTask {

        let url = urlFromComponents(Constants.Scheme, host: Constants.Host, path: method, parameters: parameters)

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in

            guard error == nil else {
                completionHandlerForPOST(result: nil, error: error)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let error = self.getError("taskForPOSTMethod", code: 2, error: "Server returned non-2xx status code")
                completionHandlerForPOST(result: nil, error: error)
                return
            }
            print("\(statusCode)")

            guard let data = data else {
                let error = self.getError("taskForPOSTMethod", code: 2, error: "Failure to retrieve data from server")
                completionHandlerForPOST(result: nil, error: error)
                return
            }

            let formattedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

            self.parseData(formattedData, completionHandlerForParseData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }

    func taskForDELETEMethod(method: String, parameters: [String: AnyObject], completionHandlerForDELETE:(result: AnyObject!, error: NSError?)->Void) -> NSURLSessionDataTask {

        let url = urlFromComponents(Constants.Scheme, host: Constants.Host, path: method, parameters: parameters)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"

        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in

            guard error == nil else {
                print("Error with DELETE request")
                completionHandlerForDELETE(result: nil, error: error)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let error = self.getError("taskForPOSTMethod", code: 2, error: "Server returned non-2xx status code")
                completionHandlerForDELETE(result: nil, error: error)
                return
            }
            print("\(statusCode)")

            guard let data = data else {
                let error = self.getError("taskForPOSTMethod", code: 2, error: "Failure to retrieve data from server")
                completionHandlerForDELETE(result: nil, error: error)
                return
            }

            let formattedData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            self.parseData(formattedData, completionHandlerForParseData: completionHandlerForDELETE)
        }
        task.resume()
        return task
    }
}
