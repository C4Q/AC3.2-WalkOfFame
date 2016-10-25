//
//  DetailViewController.swift
//  WalkOfFame
//
//  Created by Victor Zhong on 10/24/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var infoLabel: UILabel!
	
	internal var selectedWalk: Walk!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData(for: selectedWalk)
		// Do any additional setup after loading the view.
	}
	
	func loadData(for designer: Walk) {
	self.nameLabel.text = designer.designer
		self.addressLabel.text = designer.location
		self.infoLabel.text = designer.description
	}
}
