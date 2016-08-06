//
//  DetailViewController.swift
//  PracticeTime
//
//  Created by John Cook on 8/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController, ModalTransitionListener {
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let info = DataStore.sharedInstance.info! as Info
    

    @IBOutlet var weeklyTotalLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!

//    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var weekdayButton: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var barChartView:  HorizontalBarChartView!
    
    var goal = 6
    let days = ["Sat","Sun","Mon","Tues","Wed","Thurs","Fri"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // listener for resetting view
        ModalTransitionMediator.instance.setListener(self)
        
        // set title
        let instance = DataStore.sharedInstance
        let item     = instance.getItem(info.currentItem) as! Item
        self.navigationItem.title = item.name
        
        weeklyTotalLabel.text = "  This Week: \(getWeekToDateTotal()) hours" //(since \(startingDayToString()))"
        totalLabel.text = "  Total: \(item.getTotalTime()) hours"
        goalLabel.text = "  Percent to weekly goal (\(goal)):"
        
        weeklyTotalLabel.textColor = uicolorFromHex(0x2ecc71)
        weeklyTotalLabel.font = UIFont(name: "Avenir-Medium", size: 19)
        totalLabel.textColor = uicolorFromHex(0x2ecc71)
        totalLabel.font = UIFont(name: "Avenir-Medium", size: 19)
        goalLabel.textColor = uicolorFromHex(0x2ecc71)
        goalLabel.font = UIFont(name: "Avenir-Medium", size: 19)
        
        // set up week chart
        setChart(days, values: item.getWeekToDateTimes())
        lineChartView.legend.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.labelFont = UIFont(name: "Avenir-Medium", size: 12)!
        lineChartView.leftAxis.labelTextColor = uicolorFromHex(0x2ecc71)
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.xAxis.labelFont = UIFont(name: "Avenir-Medium", size: 12)!
        lineChartView.xAxis.labelTextColor = uicolorFromHex(0x2ecc71)
        lineChartView.minOffset = CGFloat(20.0)
        lineChartView.pinchZoomEnabled = false
        
        // set up goal chart
        setBarChart([""], values: [getWeekToDateTotal()])
        barChartView.legend.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.leftAxis.axisMinValue = 0.0
        barChartView.leftAxis.axisMaxValue = 6.0
        barChartView.drawMarkers = false
        barChartView.drawBordersEnabled = true
        barChartView.borderColor = uicolorFromHex(0x2ecc71)
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        do {
            try managedContext?.save()
        } catch _ {
        }
    }
    
    func uicolorFromHex(rgbValue:UInt32) -> UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func startingDayToString() -> String {
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
        var result = ["","","","","","",""]
        let days = ["S","S","M","T","W","Th","F"]
        var dayInt = info.getStartingDay()
        for i in 0...6 {
            result[i] = days[dayInt % 7]
            dayInt += 1
        }
        return result
    }
    
    func getWeekToDateTotal() -> Double {
        let item   = DataStore.sharedInstance.getItem(info.currentItem) as! Item
        var result = 0.0
        for i in item.getWeekToDateTimes() {
            result += i
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
    
    func setChart(dataPoints:[String], values: [Double]) {
        // add dataPoints to chart's dataPoints array
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        // set up line chart data
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
        let lineChartData    = LineChartData(xVals: getDayLabels(), dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        // set circle on data points and set line thickness
        lineChartDataSet.circleRadius = CGFloat(4)
        lineChartDataSet.circleColors = [uicolorFromHex(0x2ecc71)]
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.drawValuesEnabled = false
        
        // remove "Description" label from chart
        lineChartView.descriptionText = ""
        
        lineChartDataSet.colors = [uicolorFromHex(0x2ecc71)]
    }
    
    func setBarChart(dataPoints:[String], values: [Double]) {
        // add dataPoints to chart's dataPoints array
        var barDataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let barDataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            barDataEntries.append(barDataEntry)
        }
        
        // set up line chart data
        let barChartDataSet = BarChartDataSet(yVals: barDataEntries, label: "")
        let barChartData    = BarChartData(xVals: [""], dataSet: barChartDataSet)
        barChartView.data = barChartData
        
        // remove "Description" label from chart
        barChartView.descriptionText = ""
        
        barChartDataSet.colors = [uicolorFromHex(0x2ecc71)]
        barChartDataSet.drawValuesEnabled = false
    }
    
    // MARK: - ModalTransitionListener
    
    func popoverDismissed() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        let item   = DataStore.sharedInstance.getItem(info.currentItem) as! Item
        weeklyTotalLabel.text = "   This Week: \(getWeekToDateTotal()) hours" // (since \(startingDayToString()))"
        setChart(days, values: item.getWeekToDateTimes())
        setBarChart([""], values: [getWeekToDateTotal()])
    }
}

// MARK: - Date Extension

extension NSDate {
    func dayOfWeek() -> Int? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self) else { return nil }
        return comp.weekday
    }
}