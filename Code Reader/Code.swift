//
//  Code.swift
//  Code Reader
//
//  Created by Parth on 18/5/17.
//  Copyright © 2017 Parth. All rights reserved.
//

import RealmSwift

class Code: Object {
    /*
     * Format the code was created in
     */
    dynamic var type: String = ""
    
    /*
     * The actual payload of the code scanned
     */
    dynamic var message: String = ""
    
    /*
     * The time of the actual code
     */
    dynamic var date: Date = Date()
}
