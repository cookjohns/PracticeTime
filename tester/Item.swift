//
//  Piece.swift
//  tester
//
//  Created by John Cook on 12/16/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var lastAccess: NSDate
    @NSManaged var totalTime: NSNumber
    @NSManaged var timeSinceLastAccess: NSNumber
    @NSManaged var times: Dictionary<String, NSNumber> // date in DDMMYY format, totalTime for that instance
    
}
