
extension UdacityClient {

    struct Constants {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
    }

    struct Methods {
        static let UdacitySession = "/api/session"
        static let GetUserInfo = "/api/users/{userID}"
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
