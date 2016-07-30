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
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView(frame:CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
    }
    
    @IBAction
    func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self.navigationController!, animated: true)
    }
    
    @IBAction func addItem(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        //self.names.append(textField!.text!)
                                        self.saveName(textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    func saveName(input: String) {
        
        let entity =  NSEntityDescription.entityForName("Piece",
                                                        inManagedObjectContext:
            managedContext!)
        
        let piece = NSManagedObject(entity: entity!,
                                    insertIntoManagedObjectContext:managedContext)
        let today = printDate(NSDate())
        let dict: Dictionary<String, NSNumber> = [today:0]
        
        piece.setValue(input,    forKey: "title")
        piece.setValue(0,        forKey: "totalTime")
        piece.setValue(NSDate(), forKey: "lastAccess")
        piece.setValue(0.0,      forKey: "timeSinceLastAccess")
        piece.setValue(dict,     forKey: "times")
        
        do {
            try managedContext?.save()
        } catch _ {
        }
        DataStore.sharedInstance.pieceObjects.append(piece)
    }
    
    func printDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        
        let theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
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
        return DataStore.sharedInstance.pieceObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        let piece = DataStore.sharedInstance.pieceObjects[indexPath.row]
        
//        var lastAccessDate = piece.valueForKey("lastAccess") as! NSDate
        //var newLastTime = calcLastTime(lastAccessDate)
        //piece.setValue(newLastTime, forKey: "timeSinceLastAccess")
        
        let lastTime = abs(piece.valueForKey("timeSinceLastAccess") as! Double)
        cell.textLabel!.text = piece.valueForKey("title") as? String
        cell.textLabel!.font = UIFont(name: "Avenir-Medium", size:20.0)
        
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
        let lastAccessDate = lastAccessIn
        let today = NSDate()
//        var date1 = lastAccessDate
//        var date2 = today
        let distanceBetweenDates: Double = lastAccessDate.timeIntervalSinceDate(today)
        let secondsInAnHour: Double = 3600
        let hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
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
            let itemToDelete = DataStore.sharedInstance.pieceObjects[indexPath.row]
            managedContext?.deleteObject(itemToDelete)
            do {
                try managedContext?.save()
            } catch _ {
            }
            self.fetch()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        DataStore.sharedInstance.currentIndex = indexPath.row
    }
    
    func fetch() {
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = (try? managedContext!.executeFetchRequest(fetchRequest)) as? [Piece] {
            DataStore.sharedInstance.pieceObjects = fetchResults
        }
    }
    
    // set current piece in 'pieces' when a row on the table is selected
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        DataStore.sharedInstance.currentIndex = indexPath.row
        setAllTimes()  // load the allTimes dictionary that holds all total times, sets totalTimeInDict to hold sum
        return indexPath
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName:"Piece")
        
//        let error: NSError?
        
        let fetchedResults =
        (try? managedContext?.executeFetchRequest(fetchRequest)) as? [Piece]
        
        if let results = fetchedResults {
            DataStore.sharedInstance.pieceObjects = results
        } else {
            print("Could not fetch")// \(error), \(error!.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    func setAllTimes() {
        var total = 0
        for x: NSManagedObject in DataStore.sharedInstance.pieceObjects {
            total += x.valueForKey("totalTime") as! Int
        }
        DataStore.sharedInstance.totalTimeInDict = total
    }
    
    func greenColor() -> CAGradientLayer {
        let topColor = UIColor(red: (46/255.0), green: (204/255.0), blue: (113/255.0), alpha: 1)
        let bottomColor = UIColor(red: (255.0/255.0), green: (255.0/255.0), blue: (255.0/255.0), alpha: 1)
        
        let gradientColors: Array <AnyObject> = [topColor.CGColor, bottomColor.CGColor]
//        let gradientLocations: Array <AnyObject> = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        //gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}