//
//  ViewController.swift
//  PracticeTimeNew
//
//  Created by John Cook on 12/16/14.
//  Copyright (c) 2014 John Cook. All rights reserved.
//

import UIKit
import CoreData

@objc(PracticeTimeTableViewController)class PracticeTimeTableViewController: UITableViewController {
    
    let fetchRequest = NSFetchRequest(entityName: "Piece")
    let managedContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView(frame:CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PieceStorage.sharedInstance.pieceObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let piece = PieceStorage.sharedInstance.pieceObjects[indexPath.row]
        
        var lastAccessDate = piece.valueForKey("lastAccess") as NSDate
        //var newLastTime = calcLastTime(lastAccessDate)
        //piece.setValue(newLastTime, forKey: "timeSinceLastAccess")
        
        var lastTime = abs(piece.valueForKey("timeSinceLastAccess") as Double)
        cell.textLabel!.text = piece.valueForKey("title") as String
        
        
        if (lastTime <= 24.0) {
            // if it has been less than 24 hours since lastAccess, set as green
            cell.textLabel?.textColor = uicolorFromHex(0x2ecc71)
        }
        else if (lastTime > 24.0) && (lastTime < 48.0) {
            cell.textLabel?.textColor = uicolorFromHex(0xf1c40f)
        }
        else {
            cell.textLabel?.textColor = uicolorFromHex(0xe74c3c)
        }
        return cell
    }
    
    func calcLastTime(lastAccessIn: NSDate) -> Double {
        var lastAccessDate = lastAccessIn
        var today = NSDate()
        var date1 = lastAccessDate
        var date2 = today
        var distanceBetweenDates: Double = lastAccessDate.timeIntervalSinceDate(today)
        var secondsInAnHour: Double = 3600
        var hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        return hoursBetweenDates
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let itemToDelete = PieceStorage.sharedInstance.pieceObjects[indexPath.row]
            managedContext?.deleteObject(itemToDelete)
            managedContext?.save(nil)
            self.fetch()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        PieceStorage.sharedInstance.currentIndex = indexPath.row
    }
    
    func fetch() {
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = managedContext!.executeFetchRequest(fetchRequest, error: nil) as? [Piece] {
            PieceStorage.sharedInstance.pieceObjects = fetchResults
        }
    }
    
    // set current piece in 'pieces' when a row on the table is selected
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        PieceStorage.sharedInstance.currentIndex = indexPath.row
        return indexPath
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName:"Piece")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext?.executeFetchRequest(fetchRequest,
            error: nil) as? [Piece]
        
        if let results = fetchedResults {
            PieceStorage.sharedInstance.pieceObjects = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
}

