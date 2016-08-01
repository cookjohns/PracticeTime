//
//  Folder.swift
//  PracticeTime
//
//  Created by John Cook on 8/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import Foundation
import CoreData

class Folder: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var items: [Item]
}