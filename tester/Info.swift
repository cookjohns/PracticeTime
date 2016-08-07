//
//  Info.swift
//  Charts
//
//  Created by John Cook on 8/5/16.
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation
import CoreData

class Info: NSManagedObject {
    
    /* Singleton */
    class var sharedInstance: Info {
        struct Static {
            static var instance: Info?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Info()
        }
        return Static.instance!
    }
    
    @NSManaged var name: String
    
    @NSManaged var allTimes: Dictionary<String, NSNumber>!
        
    @NSManaged var totalTimeInDict: Int
        
    @NSManaged var currentItem:  Int
        
    @NSManaged var currentFolder: Int
        
    @NSManaged var startingDay: Int // Saturday = 0
    
    func getStartingDay() -> Int {
        return startingDay
    }
    
    func changeStartingDay(input: Int) {
        startingDay = input
    }
}