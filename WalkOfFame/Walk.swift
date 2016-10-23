//
//  walkfOfFame.swift
//  throwAway
//
//  Created by C4Q on 10/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class Walk {
    let designer: String
    let location: String
    let description: String
    let sketchURL: URL
    
    init(designer: String, location: String, description: String, sketchURL: URL) {
        self.designer = designer
        self.location = location
        self.description = description
        self.sketchURL = sketchURL
    }
    
    convenience init? (withArray: [Any]) {
        if let designer = withArray[8] as? String,
            let location = withArray[9] as? String,
            let description = withArray[10] as? String,
            let sketchString = withArray[11] as? String,
            let sketchURL = URL(string: sketchString)  {
            self.init(designer: designer, location: location, description: description, sketchURL: sketchURL)
            
        } else {return nil}
    }
    
    convenience init?(withDict: [String:String]) {
        if let designer = withDict["designer"],
            let location = withDict["location"],
            let description = withDict["info"],
            let sketchString = withDict["sketch_by_designer"],
            let sketchURL = URL(string: sketchString) {
            
            self.init(designer: designer, location: location, description: description, sketchURL: sketchURL)
        }
        else {return nil}
    }
    
}
