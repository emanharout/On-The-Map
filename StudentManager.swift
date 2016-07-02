//
//  StudentManager.swift
//  On the Map
//
//  Created by Emmanuoel Eldridge on 7/2/16.
//  Copyright © 2016 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class StudentManager: NSObject {
    
    static var sharedInstance = StudentManager()
    
    var studentArray = [StudentInformation]()
    
    private override init() {
    }
}
