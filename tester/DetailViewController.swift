//
//  DetailViewController.swift
//  PracticeTime
//
//  Created by John Cook on 8/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
    
    let item = DataStore.sharedInstance.getItem(DataStore.sharedInstance.currentItem!)
    

    @IBOutlet var weeklyTotalLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!

    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var weekdayButton: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var barChartView:  HorizontalBarChartView!
    
    var GOAL = 20.0
    
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
        
        weeklyTotalLabel.text = "   This Week: \(item.getWeekTotal()) (since \(startingDayToString()))"
        totalLabel.text = "   Total: \(item.getTotalTime())"
        goalLabel.text = "   Percent to weekly goal:"
        
        weeklyTotalLabel.textColor = uicolorFromHex(0x2ecc71)
        weeklyTotalLabel.font = UIFont(name: "Avenir-Medium", size: 19)
        totalLabel.textColor = uicolorFromHex(0x2ecc71)
        totalLabel.font = UIFont(name: "Avenir-Medium", size: 19)
        goalLabel.textColor = uicolorFromHex(0x2ecc71)
        goalLabel.font = UIFont(name: "Avenir-Medium", size: 19)
        
        // set up chart
        let days = ["Sat","Sun","Mon","Tues","Wed","Thurs","Fri"]
        let tempTimeData = [1.5, 2.75, 0.5, 1.75, 4.5, 3.0, 2.75]
        setChart(days, values: tempTimeData)
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
        
        let percentMarkers = [""]
        var percentToGoal  = Double(Double(item.getWeekTotal()) / GOAL) * 100
        setBarChart(percentMarkers, values: [percentToGoal])
        barChartView.legend.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.leftAxis.axisMinValue = 0.0
        barChartView.leftAxis.axisMaxValue = 100.0
        barChartView.drawMarkers = false
        barChartView.drawBordersEnabled = true
        barChartView.borderColor = uicolorFromHex(0x2ecc71)
    }
    
    func uicolorFromHex(rgbValue:UInt32) -> UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func startingDayToString() -> String {
        let dayInt = DataStore.sharedInstance.getStartingDay()
        switch (dayInt) {
        case 0:
            return "Saturday"
            break
        case 1:
            return "Sunday"
            break
        case 2:
            return "Monday"
            break
        case 3:
            return "Tuesday"
            break
        case 4:
            return "Wednesday"
            break
        case 5:
            return "Thursday"
            break
        case 6:
            return "Friday"
            break
        default:
            return "------"
        }
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
        let lineChartData    = LineChartData(xVals: ["S","S","M","T","W","Th","F"], dataSet: lineChartDataSet)
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
}
