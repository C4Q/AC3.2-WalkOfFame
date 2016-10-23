//
//  WOFDetailViewController.swift
//  WalkOfFame
//
//  Created by Ana Ma on 10/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class WOFDetailViewController: UIViewController {
    var wof: Walk?
    
    @IBOutlet weak var designerLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sketchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        // Do any additional setup after loading the view.
    }

    func setupData() {
        guard let WOF = wof else {return}
        designerLabel.text = WOF.designer
        descriptionTextView.text = WOF.description
        locationLabel.text = WOF.location
        sketchLabel.text = String(describing: WOF.sketchURLString)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
