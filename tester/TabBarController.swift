//
//  TabBarController.swift
//  FrostedSidebar
//
//  Created by Evan Dekhayser on 8/28/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
	
	var sidebar: FrostedSidebar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		tabBar.hidden = true
		
		sidebar = FrostedSidebar(itemImages: [
			UIImage(named: "list"   )!,
			UIImage(named: "folder" )!,
			UIImage(named: "chart"  )!,
			UIImage(named: "gear"   )!],
			colors: [
                UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1),
                UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1),
                UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1),
                UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1) ],
			selectedItemIndices: NSIndexSet(index: 0))
		
		sidebar.isSingleSelect = true
		sidebar.actionForIndex = [
			0: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 0}) },
			1: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 1}) },
			2: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 2}) },
			3: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 3}) }]
	}
}