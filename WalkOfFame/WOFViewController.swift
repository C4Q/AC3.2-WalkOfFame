//
//  WOFViewController.swift
//  WalkOfFame
//
//  Created by Annie Tung on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class WOFViewController: UIViewController {

    @IBOutlet weak var designerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var walks: Walk?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let w = walks {
            designerLabel.text = w.designer
            locationLabel.text = "Location: \(w.location)"
            descriptionLabel.text = w.description
        }
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
