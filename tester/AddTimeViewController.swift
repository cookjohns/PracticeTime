//
//  AddTimeViewController.swift
//  PracticeTime
//
//  Created by John Cook on 8/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class AddTimeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Variables
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let info = DataStore.sharedInstance.info! as Info
    
    let pickerData = [
        ["0 hours","1 hour","2 hours","3 hours","4 hours"],
        ["0 minutes", "15 minutes", "30 minutes", "45 minutes"]
    ]
    
    enum PickerComponent: Int {
        case hours = 0
        case minutes = 1
    }
    
    @IBOutlet weak var timeLabel:  UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size:23.0)!, NSForegroundColorAttributeName: uicolorFromHex(0xffffff)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x2ecc71)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem?.tintColor  = UIColor.whiteColor()
        
        timeLabel.textColor = UIColor.blackColor()
        timeLabel.font      = UIFont(name: "Avenir-Medium", size: 17)
        
        timePicker.delegate        = self
        timePicker.dataSource      = self
        timePicker.backgroundColor = uicolorFromHex(0xecf0f1)
        timePicker.selectRow(2, inComponent: PickerComponent.hours.rawValue, animated: false)
        timePicker.setValue(UIColor.blackColor(), forKeyPath: "textColor")
        timePicker.setValue(0.8, forKeyPath: "alpha")
        
        datePicker.backgroundColor = uicolorFromHex(0xecf0f1)
        datePicker.setValue(UIColor.blackColor(), forKeyPath: "textColor")
        datePicker.setValue(0.8, forKeyPath: "alpha")
        
        updateLabel()
    }
    
    override func viewWillDisappear(animated: Bool) {
        ModalTransitionMediator.instance.sendPopoverDismissed(true)
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        let hoursComponent   = PickerComponent.hours.rawValue
        let minutesComponent = PickerComponent.minutes.rawValue
        
        // calculate hours from picker
        var hours = Double(timePicker.selectedRowInComponent(hoursComponent))
        switch (timePicker.selectedRowInComponent(minutesComponent)) {
        case 0:
            break
        case 1:
            hours += 0.25
            break
        case 2:
            hours += 0.5
            break
        case 3:
            hours += 0.75
        default:
            break
        }
        
        // save time
        let item = DataStore.sharedInstance.getItem(info.currentItem) as! Item
        item.addTime(hours, date: datePicker.date)
        
        do {
            try managedContext?.save()
        } catch _ {
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK - Picker Delgates and DataSource
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    // MARK: - Formatting
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func updateLabel() {
        let hoursComponent   = PickerComponent.hours.rawValue
        let minutesComponent = PickerComponent.minutes.rawValue
        let hours      = pickerData[hoursComponent][timePicker.selectedRowInComponent(hoursComponent)]
        let minutes    = pickerData[minutesComponent][timePicker.selectedRowInComponent(minutesComponent)]
        timeLabel.text = "  Time to add: " + hours + " " + minutes
    }
}