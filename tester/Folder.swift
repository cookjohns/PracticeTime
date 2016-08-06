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
    @NSManaged var items: [Int]
    
    func addItem(input: Int) {
        items.append(input)
    }
    
    func deleteItem(input: Item) {
        for i in 0..<items.count {
//            let item = items[i] as! Item
            let item = DataStore.sharedInstance.getItem(i) as! Item
            if item.name == input.name {
                items.removeAtIndex(i)
            }
        }
    }
    
    func getItem(index: Int) -> Item {
//        return items[index] as! Item
        return DataStore.sharedInstance.getItem(index) as! Item
    }
}