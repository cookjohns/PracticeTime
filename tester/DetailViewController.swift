//
//  DetailViewController.swift
//  PracticeTime
//
//  Created by John Cook on 8/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let item = DataStore.sharedInstance.getItem(DataStore.sharedInstance.currentItem!)
    

    @IBOutlet var weeklyTotalLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // set title
        let instance = DataStore.sharedInstance
        let item     = instance.getItem(instance.currentItem!) as! Item
        self.navigationItem.title = item.name
        
        weeklyTotalLabel.text = "Weekly Total: \(item.getWeekTotal())"
        totalLabel.text = "Total: \(item.getTotalTime())"
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
}
