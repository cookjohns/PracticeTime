//
//  FolderPopUpViewController.swift
//  PracticeTime
//
//  Created by John Cook on 8/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit
import CoreData

class FolderPopOverViewController: UITableViewController {
    
    let folderFetchRequest = NSFetchRequest(entityName: "Folder")
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    let instance = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        // test
        let item = instance.getItem(instance.currentItem!) as! Item
        print("name: \(item.name)")
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instance.folderObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let item = instance.folderObjects[indexPath.row]
        
        cell.textLabel!.text = item.valueForKey("name") as? String
        cell.textLabel!.font = UIFont(name: "Avenir-Medium", size:20.0)
        cell.textLabel?.textColor = uicolorFromHex(0x2ecc71)
        
        return cell
    }
    
    // FIXME: - Item-in-folder PERSISTENCE
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = instance.getItem(instance.currentItem!) as! Item
        let folder = instance.getFolder(indexPath.item) as! Folder
        folder.addItem(item)
        folder.setValue(folder.items, forKey: "items")
        
//        do {
//            //try managedContext?.save()
//            try folder.managedObjectContext!.save()
//        } catch _ {
//        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetch() {
        let folderFetchRequest = NSFetchRequest(entityName: "Folder")
        let itemFetchRequest = NSFetchRequest(entityName: "Item")
        
        
        // Create a sort descriptor object that sorts on the "name"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        folderFetchRequest.sortDescriptors = [sortDescriptor]
        itemFetchRequest.sortDescriptors = [sortDescriptor]
        
        if let folderFetchResults = (try? managedContext!.executeFetchRequest(folderFetchRequest)) as? [Folder] {
            DataStore.sharedInstance.folderObjects = folderFetchResults
        }
        if let itemFetchResults = (try? managedContext!.executeFetchRequest(itemFetchRequest)) as? [Item] {
            DataStore.sharedInstance.itemObjects = itemFetchResults
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        let fetchRequest = NSFetchRequest(entityName:"Folder")
//        
//        let fetchedResults =
//            (try? managedContext?.executeFetchRequest(fetchRequest)) as? [Folder]
//        
//        if let results = fetchedResults {
//            DataStore.sharedInstance.folderObjects = results
//        } else {
//            print("Could not fetch")// \(error), \(error!.userInfo)")
//        }
        self.fetch()
        self.tableView.reloadData()
    }
}