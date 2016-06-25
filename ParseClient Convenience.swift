//
//  ParseClient Convenience.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/24/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocations(limit: Int, skip: Int, order: String, completionHandlerForGetStudentLocation: (result: [StudentInformation]?, error: NSError?)->Void) {
        
        let parameters: [String: AnyObject] = ["limit": limit, "skip": skip, "order": order]
        
        taskForGETMethod(ParseClient.Constants.Scheme, host: ParseClient.Constants.Host, path: ParseClient.Methods.StudentLocation, parameters: parameters) { (result, error) in
            
            if let error = error {
                completionHandlerForGetStudentLocation(result: nil, error: error)
                
            } else if let result = result {
                guard let studentsInfo = result["results"] as? [[String: AnyObject]] else {
                    let error = self.getError("getStudentLocations", code: 11, error: "Error accessing results with Student dictionaries")
                    completionHandlerForGetStudentLocation(result: nil, error: error)
                    return
                }
                for student in studentsInfo {
                    let newStudent = StudentInformation(studentDict: student)
                    StudentInformation.studentArray.append(newStudent)
                }
                completionHandlerForGetStudentLocation(result: StudentInformation.studentArray, error: nil)
            }
        }
    }
}