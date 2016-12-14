//
//  SettingsViewController.swift
//  PracticeTime
//
//  Created by John Cook on 8/7/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UITableViewController, SKStoreProductViewControllerDelegate {
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var iCloudLabel:   UILabel!
    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var upgradeLabel:  UILabel!
    @IBOutlet weak var shareLabel:    UILabel!
    @IBOutlet weak var rateLabel:     UILabel!
    @IBOutlet weak var iCloudSwitch:  UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem?.tintColor  = UIColor.whiteColor()
        
        self.iCloudLabel.font       = UIFont(name: "Avenir-Light", size: 17)
        self.startDayLabel.font     = UIFont(name: "Avenir-Light", size: 17)
        self.upgradeLabel.font      = UIFont(name: "Avenir-Light", size: 17)
        self.shareLabel.font        = UIFont(name: "Avenir-Light", size: 17)
        self.rateLabel.font         = UIFont(name: "Avenir-Light", size: 17)
        
        iCloudSwitch.addTarget(self, action: #selector(SettingsViewController.stateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        let info = DataStore.sharedInstance.info! as Info
        iCloudSwitch.on = info.iCloudActive
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
    
    @IBAction func shareButtonClicked(sender: UIButton) {
        let textToShare = "Check out the PracticeTime+ app!"
        
        if let appListing = NSURL(string: "http://google.com/") {
            let objectsToShare = [textToShare, appListing]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            // excluded activities code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func rateMe(sender: AnyObject) {
//        if #available(iOS 8.0, *) {
//            openStoreProductWithiTunesItemIdentifier("107698237252");
//        } else {
            var url  = NSURL(string: "itms-apps://itunes.apple.com/us/app/xxxxxxxxxxx/id107698237252?ls=1&mt=8")
            if UIApplication.sharedApplication().canOpenURL(url!) == true  {
                UIApplication.sharedApplication().openURL(url!)
            }
//
//        }
    }
    
    @IBAction func goToProApp(sender: AnyObject) {
        //        if #available(iOS 8.0, *) {
        //            openStoreProductWithiTunesItemIdentifier("107698237252");
        //        } else {
        var url  = NSURL(string: "itms-apps://itunes.apple.com/us/app/xxxxxxxxxxx/id107698237252?ls=1&mt=8")
        if UIApplication.sharedApplication().canOpenURL(url!) == true  {
            UIApplication.sharedApplication().openURL(url!)
        }
        //
        //        }
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProductWithParameters(parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                self?.presentViewController(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func stateChanged(switchState: UISwitch) {
        let info = DataStore.sharedInstance.info! as Info
        if switchState.on {
            info.iCloudActive = true
        } else {
            info.iCloudActive = false
        }
        do {
            try managedContext?.save()
        } catch _ {
        }
    }
    
    
    // MARK: - Formatting
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // share
        if indexPath.section == 2 && indexPath.row == 0 {
            shareButtonClicked(UIButton())
        }
        
        // rate
        if indexPath.section == 2 && indexPath.row == 1 {
            rateMe(UIButton())
        }
        
        // go pro
        if indexPath.section == 1 && indexPath.row == 0 {
            goToProApp(UIButton())
        }
    }

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//
//        // Configure the cell...
//        if indexPath.row == 0 {
//            self.iCloudLabel.text = "iCloud Sync"
//        }
//
//        return cell
//    }
 

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
