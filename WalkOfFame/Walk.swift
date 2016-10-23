//
//  Walk.swift
//  WalkOfFame
//
//  Created by Jason Gresh on 10/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class Walk {
    let designer: String
    let description: String
    let location: String
    let sketchURLString: String
    
    init(designer: String, location: String, description: String, sketchURLString: String) {
        self.designer = designer
        self.description = description
        self.location = location
        self.sketchURLString = sketchURLString
    }
    
    convenience init?(withArray arr: [Any]) {
        if let design = arr[8] as? String,
            let descript = arr[9] as? String,
            let loc = arr[10] as? String,
            let sketch = arr[11] as? String  {
            self.init(designer: design, location: loc, description: descript, sketchURLString: sketch)
        }
        else {
            return nil
        }
    }
    /*
    {
    designer: "Stephen Burrows",
    info: "Stephen Burrows, best known for fluid body-conscious clothes in bold colors, “stretches a rainbow over the body,” said one admirer. In 1970 he opened a boutique called Stephen Burrows’ World and Henri Bendel, where he sold his famous jersey dresses with rippled “lettuce” hems. Other trademarks include bold color blocking, decorative stitching and innovative styles in suede and leather. Burrows’ vivacious clothes were featured in the 1973 epochal American fashion show at Versailles.",
    location: "577 7th Avenue",
    sketch_by_designer: "FC_Walk_of_Fame_plaque_1.jpg"
    }
     */
    
    convenience init? (withDict dict:[String:Any]) {
        if let designer = dict["designer"] as? String,
            let description = dict["info"] as? String,
            let location = dict["location"] as? String,
            let sketch = dict["sketch_by_designer"] as? String {
            self.init(designer: designer, location:location, description: description, sketchURLString: sketch)
        } else {
            return nil
        }
    }
    
}
