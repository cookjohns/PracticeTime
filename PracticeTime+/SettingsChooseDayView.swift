//
//  settingsChooseDayView.swift
//  PracticeTime
//
//  Created by John Cook on 8/7/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class SettingsChooseDayView: UITableViewController {
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var selectedIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the empty cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem?.tintColor  = UIColor.whiteColor()
        
        let info = DataStore.sharedInstance.info! as Info
        selectedIndex = info.getStartingDay() > 1 ? info.getStartingDay() - 2 : info.getStartingDay() + 5

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func done(sender: AnyObject) {
        // add saving done in sub-pages, so just dismiss
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7 // days in a week
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // do the checkmark
        if(indexPath.row == selectedIndex)
        {
            cell.accessoryType = .Checkmark;
        }
        else
        {
            cell.accessoryType = .None;
        }
        
        var labelText = ""
        
        switch (indexPath.row) {
            case 0:
            labelText = "Monday"
            case 1:
            labelText = "Tuesday"
            case 2:
            labelText = "Wednesday"
            case 3:
            labelText = "Thursday"
            case 4:
            labelText = "Friday"
            case 5:
            labelText = "Saturday"
            case 6:
            labelText = "Sunday"
            default:
            labelText = "------"
        }
        
        cell.textLabel!.font = UIFont(name: "Avenir-Light", size: 17.0)
        cell.textLabel!.text = labelText
        // for changing checkmark color
        cell.tintColor = UIColor.blackColor()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // set checkmark
        selectedIndex = indexPath.row;
        tableView.reloadData()
        
        let info = DataStore.sharedInstance.info! as Info
        
        // set new starting day
        switch (indexPath.row) {
        case 0:
            info.changeStartingDay(2)
        case 1:
            info.changeStartingDay(3)
        case 2:
            info.changeStartingDay(4)
        case 3:
            info.changeStartingDay(5)
        case 4:
            info.changeStartingDay(6)
        case 5:
            info.changeStartingDay(0)
        case 6:
            info.changeStartingDay(1)
        default:
            print("changeStartingDay not called")
        }
            
        // save
        do {
            try managedContext?.save()
        } catch _ {
        }
        if (info.iCloudActive) {
            DataStore.sharedInstance.seamStore!.triggerSync()
        }
    }
    
    // MARK: - Formatting
    
    func uicolorFromHex(rgbValue:UInt32)-> UIColor {
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
