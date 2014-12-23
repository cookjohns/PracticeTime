//
//  PieceStorage.swift
//  PracticeTimeNew
//
//  Created by John Cook on 12/16/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import Foundation
import CoreData

class PieceStorage {
    class var sharedInstance: PieceStorage {
        struct Static {
            static var instance: PieceStorage?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PieceStorage()
        }
        return Static.instance!
    }
    
    var pieceObjects = [NSManagedObject]()
    
    var currentIndex: Int?
    
    //var count: Int = sharedInstance.pieceObjects.count
    
    func get(index: Int) -> NSManagedObject {
        return pieceObjects[index]
    }
    
}