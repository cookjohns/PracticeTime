//
//  TotalsViewController.swift
//  PracticeTime
//
//  Created by John Cook on 8/6/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit
//import Charts

class TotalsViewController: UIViewController {
    
    // MARK: - Variables
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet var weeklyTotalLabel: UILabel!
    @IBOutlet var totalLabel:       UILabel!
    @IBOutlet weak var goalLabel:   UILabel!
    
    @IBOutlet weak var barChartView:  BarChartView!
    @IBOutlet weak var goalChartView: HorizontalBarChartView!
    
    var goal = 20
    let days = ["Sat","Sun","Mon","Tues","Wed","Thurs","Fri"]
    
    // MARK: - viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let info = DataStore.sharedInstance.info! as Info
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // set title
        self.navigationItem.title = "Totals"
                
        weeklyTotalLabel.text = "  This Week: \(self.getWeekToDateTotal()) hours"
        totalLabel.text       = "  All-time Total: \(self.getTotalTime()) hours"
        goalLabel.text        = "  Percent to weekly goal (\(info.getWeeklyGoal())):"
        
        weeklyTotalLabel.textColor = UIColor.blackColor()
        weeklyTotalLabel.font      = UIFont(name: "Avenir-Light", size: 18)
        totalLabel.textColor       = UIColor.blackColor()
        totalLabel.font            = UIFont(name: "Avenir-Light", size: 18)
        goalLabel.textColor        = UIColor.blackColor()
        goalLabel.font             = UIFont(name: "Avenir-Light", size: 18)
        
        // set up folders chart
        if DataStore.sharedInstance.folderCount() > 0 {
            setChart(self.getFolderNames(), values: self.getWeekToDateFolderTimes())
        }
        
        // set up goal chart
        if DataStore.sharedInstance.itemCount() > 0 {
            setGoalChart([""], values: [getWeekToDateTotal()])
        }
    }
    
    // reload lables and charts when switching back to Totals tab
    override func viewWillAppear(animated: Bool) {
        let info = DataStore.sharedInstance.info! as Info
        
        weeklyTotalLabel.text = "  This Week: \(self.getWeekToDateTotal()) hours"
        totalLabel.text       = "  All-time Total: \(self.getTotalTime()) hours"
        goalLabel.text        = "  Percent to weekly goal (\(info.getWeeklyGoal())):"
        
        if DataStore.sharedInstance.folderCount() > 0 {
            setChart(self.getFolderNames(), values: self.getWeekToDateFolderTimes())
        }
        setGoalChart([""], values: [getWeekToDateTotal()])
        
        if (info.iCloudActive) {
            DataStore.sharedInstance.seamStore!.triggerSync()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        do {
            try managedContext?.save()
        } catch _ {
        }
    }
    
    // MARK: - Actions
    
    @IBAction func changeGoal(sender: AnyObject) {
        let info = DataStore.sharedInstance.info! as Info
        let alert = UIAlertController(title:   "Change Goal",
                                      message: "Enter new goal",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        // set new goal property
                                        info.changeWeeklyGoal(Int(textField!.text!)!)
                                        // reload goal chart and label
                                        self.setGoalChart([""], values: [self.getWeekToDateTotal()])
                                        self.goalLabel.text = "  Percent to weekly goal (\(info.getWeeklyGoal())):"
                                        
                                        // save
                                        do {
                                            try self.managedContext?.save()
                                        } catch _ {
                                        }
                                        
//                                        DataStore.sharedInstance.seamStore!.triggerSync()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated:   true,
                              completion: nil)
    }
    
    // MARK: - Getter Functions
    
    // get total time from each folder for setChart()
    func getWeekToDateFolderTimes() -> [Double] {
        let folders = DataStore.sharedInstance.getAllFolders()
        var result: [Double] = []
        for f in folders {
            let folder = f as! Folder
            var total  = 0.0
            var i = 0
//            for i in folder.getItems() {
//                let item = i as! Item
//                total += item.getWeekToDateTotal()
//                print("Folder: \(folder.getName()), Item: \(item.getName()), Hours: \(item.getWeekToDateTotal())")
//            }
            while i < folder.itemCount() {
                // get item
                let itemName = folder.getNameAtIndex(i)
                let item = DataStore.sharedInstance.getItem(itemName) as! Item
                total += item.getWeekToDateTotal()
                i += 1
            }
            result.append(total)
            total = 0.0
        }
        return result
    }
    
    func getWeekToDateTotal() -> Double {
        let items = DataStore.sharedInstance.getAllItems()
        var total = 0.0
        for i in items {
            let item = i as! Item
            total += item.getWeekToDateTotal()
        }
        return total
    }
    
    // get total time for all items
    func getTotalTime() -> Double {
        let items = DataStore.sharedInstance.getAllItems()
        var total = 0.0
        for i in items {
            let item = i as! Item
            total += item.getTotalTime()
        }
        return total
    }
    
    func getFolderNames() -> [String] {
        var result: [String] = []
        let folders = DataStore.sharedInstance.getAllFolders()
        for f in folders {
                let folder = f as! Folder
                if folder.getName().characters.count > 4 {
                    result.append((folder.getName() as NSString).substringToIndex(4))
                }
                else {
                    result.append(folder.getName())
                }
        }
        return result
    }
    
    // MARK: - Chart Setters
    
    func setChart(dataPoints:[String], values: [Double]) {
        // add dataPoints to chart's dataPoints array
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        // set up line chart data
        let barChartDataSet = BarChartDataSet(yVals: dataEntries, label: "")
        let barChartData    = BarChartData(xVals: dataPoints, dataSet: barChartDataSet)
        barChartView.data   = barChartData
        
        // set fonts and colors
        barChartView.leftAxis.labelFont      = UIFont(name: "Avenir-Medium", size: 12)!
        barChartView.leftAxis.labelTextColor = UIColor.blackColor()
        barChartView.xAxis.labelFont         = UIFont(name: "Avenir-Medium", size: 12)!
        barChartView.xAxis.labelTextColor    = UIColor.blackColor()
        barChartDataSet.colors               = [uicolorFromHex(0x2ecc71)]
        
        // remove lines
        barChartView.leftAxis.drawGridLinesEnabled  = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled      = false
        barChartView.leftAxis.drawAxisLineEnabled   = false
        barChartView.rightAxis.drawAxisLineEnabled  = false
        barChartView.xAxis.drawGridLinesEnabled     = false
        
        // animate
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)

        // label/description/legend formatting
        barChartView.legend.enabled              = false
        barChartView.xAxis.labelPosition         = .Bottom
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartDataSet.colors                   = [uicolorFromHex(0x2ecc71)]
        barChartView.descriptionText             = ""
        
        // various others
        barChartView.leftAxis.axisMinValue  = 0.0
        barChartView.minOffset              = CGFloat(20.0)
        barChartView.pinchZoomEnabled       = false
        barChartView.userInteractionEnabled = false
        barChartDataSet.drawValuesEnabled   = false
        barChartView.setVisibleXRangeMaximum(6.0) // set maximum showing folders to 6
    }
    
    func setGoalChart(dataPoints:[String], values: [Double]) {
        // add dataPoints to chart's dataPoints array
        var barDataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let barDataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            barDataEntries.append(barDataEntry)
        }
        
        // set up line chart data
        let barChartDataSet = BarChartDataSet(yVals: barDataEntries, label: "")
        let barChartData    = BarChartData(xVals: [""], dataSet: barChartDataSet)
        goalChartView.data  = barChartData
        
        // set colors
        barChartDataSet.colors    = [uicolorFromHex(0x2ecc71)]
        goalChartView.borderColor =  uicolorFromHex(0x2ecc71)
        
        // remove grid lines
        goalChartView.xAxis.drawGridLinesEnabled     = false
        goalChartView.leftAxis.drawGridLinesEnabled  = false
        goalChartView.rightAxis.drawGridLinesEnabled = false
        
        // animate
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)

        // labels/description/legend formatting
        goalChartView.rightAxis.drawLabelsEnabled = false
        goalChartView.leftAxis.drawLabelsEnabled  = false
        goalChartView.legend.enabled  = false
        goalChartView.descriptionText = ""
        
        // various others
        goalChartView.leftAxis.axisMinValue  = 0.0
        goalChartView.leftAxis.axisMaxValue  = 20.0
        goalChartView.drawMarkers            = false
        goalChartView.drawBordersEnabled     = false
        goalChartView.userInteractionEnabled = false
        barChartDataSet.drawValuesEnabled    = false
    }
    
    // MARK: - Formatting
    
    func uicolorFromHex(rgbValue:UInt32) -> UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func startingDayToString() -> String {
        let info = DataStore.sharedInstance.info! as Info
        
        let dayInt = info.getStartingDay()
        switch (dayInt) {
        case 0:
            return "Saturday"
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "------"
        }
    }
    
    func getDayLabels() -> [String] {
        let info = DataStore.sharedInstance.info! as Info
        
        var result = ["","","","","","",""]
        let days   = ["S","S","M","T","W","Th","F"]
        var dayInt = info.getStartingDay()
        for i in 0...6 {
            result[i] = days[dayInt % 7]
            dayInt += 1
        }
        return result
    }
    
    func printDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        
        let theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
    }
}