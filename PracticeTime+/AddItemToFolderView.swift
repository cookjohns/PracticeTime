//
//  AddItemToFolderView.swift
//  PracticeTime
//
//  Created by John Cook on 8/8/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class AddItemToFolderView: UITableViewController {
    
    let managedContext     = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: - viewDid

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // set title
        let info = DataStore.sharedInstance.info! as Info
        let folder = (DataStore.sharedInstance.getFolder(info.getCurrentFolder()) as! Folder)
        self.navigationItem.title = "Add item to \(folder.name)"
    }
    
    override func viewWillDisappear(animated: Bool) {
        ModalTransitionMediator.instance.sendPopoverDismissed(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - UITableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.sharedInstance.itemCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.font = UIFont(name: "Avenir-Light", size: 19)
        cell.textLabel?.textColor = UIColor.blackColor()
        
        let info = DataStore.sharedInstance.info! as Info!
        let folder = DataStore.sharedInstance.getFolder(info.getCurrentFolder()) as! Folder

        let item = DataStore.sharedInstance.getItem(indexPath.row)
            
        cell.textLabel!.text = item.valueForKey("name") as? String
        
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let instance = DataStore.sharedInstance
        let info = DataStore.sharedInstance.info! as Info
        let folder = (DataStore.sharedInstance.getFolder(info.getCurrentFolder()) as! Folder)
        let itemToAdd = instance.getItem(indexPath.row) as! Item

        if instance.itemCount() > 0 && !(folder.containsItem(itemToAdd.getName())){
            var test = itemToAdd.getName()
            folder.addItem(itemToAdd.getName())
            
            do {
                try managedContext?.save()
            } catch _ {
            }
        }
        folder.saveItems()
        
//        DataStore.sharedInstance.seamStore!.triggerSync()
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: - Formatting
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
