//
//  ParseClient Convenience.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 6/24/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocations(limit: Int, skip: Int, order: String) {
        
        let parameters: [String: AnyObject] = ["limit": limit, "skip": skip, "order": order]
        
        taskForGETMethod(ParseClient.Constants.Scheme, host: ParseClient.Constants.Host, path: ParseClient.Methods.StudentLocation, parameters: parameters) { (result, error) in
            
            print("We are here0")
            
            if let error = error {
                print(error.localizedDescription)
                print("We are here1")
            } else if let result = result {
                
                guard let studentsInfo = result["results"] as? [[String: AnyObject]] else {
                    self.getError("Error in Parse taskForGETMethod Completion Handler", code: 11, error: "Error accessing results with Student dictionaries")
                    print("We are here2")
                    return
                }
                
                for student in studentsInfo {
                    let newStudent = StudentInformation(studentDict: student)
                    StudentInformation.studentArray.append(newStudent)
                    print("STUDENT ADDED TO ARRAY")
                }
                
                print("We are here4")
            }
            
        }
        
    }
    
    
    
}