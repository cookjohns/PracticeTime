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
    
    @NSManaged var name:  String
    @NSManaged var items: [Int] // holds indices of objects in DataStore.itemObjects
    
    func addItem(input: Int) {
        items.append(input)
    }
    
    func getName() -> String {
        return name
    }
    
    func changeName(input: String) {
        name = input
    }
    
    func deleteItem(input: Item) {
        for i in 0..<items.count {
            let item = DataStore.sharedInstance.getItem(i) as! Item
            if item.name == input.name {
                items.removeAtIndex(i)
            }
        }
    }
    
    func getItem(index: Int) -> Item {
//        return items[index] as! Item
        return DataStore.sharedInstance.getItem(items[index]) as! Item
    }
    
    func getItems() -> [NSManagedObject] {
        var result: [NSManagedObject] = []
        let allItems = DataStore.sharedInstance.getAllItems() // DataStore.itemObjects
        for i in 0..<items.count {
            let itemToAdd = allItems[items[i]]
            result.append(itemToAdd)
        }
        return result
    }
}