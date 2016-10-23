//
//  WOFTableViewController.swift
//  WalkOfFame
//
//  Created by Jason Gresh on 10/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class WOFTableViewController: UITableViewController {
    let WOFTableViewCellIdentifier: String = "WOFIdentifier"
    let WOFJSONFileName: String = "walk_of_fame.json"
    let WOFEndpoint: String = "https://data.cityofnewyork.us/resource/btth-hrxi.json"
    var walks = [Walk]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let resourceURL = getResourceURL(from: "walk_of_fame", withExt: "json"),
//        let data = getData(from: resourceURL),
//            let walks = getWalks(from: data) {
//            self.walks = walks
//        }
        getWalks(apiEndpoint: WOFEndpoint){ (returnedWalks: [Walk]?) in
            if let unwrappedreturnedWalks = returnedWalks {
                self.walks = unwrappedreturnedWalks
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return walks.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WOFTableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = walks[indexPath.row].designer
        cell.detailTextLabel?.text = walks[indexPath.row].location

     // Configure the cell...
     
     return cell
     }
    
    
    internal func getResourceURL(from fileName: String, withExt ext: String) -> URL? {
        let fileURL: URL? = Bundle.main.url(forResource: fileName, withExtension: ext)
        
        return fileURL
    }
    
    internal func getData(from url: URL) -> Data? {
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    internal func getWalks(from jsonData: Data) -> [Walk]? {
        // replace this return with a full implementation
        do {
            let WOFJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            //guard let WOFJSONCasted: [String : AnyObject] = WOFJSONData as? [String : AnyObject],
            //let WOFArray: [AnyObject] = WOFJSONCasted["data"] as? [AnyObject] else {
            //    return nil
            //}
            if let dict = WOFJSONData as? [String:Any]{
                if let WOFdata = dict["data"] as? [[Any]] {
                    for WOF in WOFdata {
                        if let w = Walk(withArray: WOF) {
                            walks.append(w)
                        }
                        /*
                         if let designer = WOF[8] as? String,
                         let description = WOF[9] as? String,
                         let loc = WOF[10] as? String,
                         let sketch = WOF[11] as? String {
                         walks.append(Walk(designer: designer, location: loc, description: description, sketchURLString: sketch))
                         }
                         */
                    }
                }
            }
            return walks
        }
        catch let error as NSError {
            // JSONSerialization doc specficially says an NSError is returned if JSONSerialization.jsonObject(with:options:) fails
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }

        return nil
    }
    
    func getWalks(fromInDictionary JSONData: Data) -> [Walk]? {
        do {
            var walkArray = [Walk]()
            
            let walkJSONData: Any = try JSONSerialization.jsonObject(with: JSONData, options: [])
            
            if let WOFJSONCasted: [[String:String]] = walkJSONData as? [[String:String]]{
                for walk in WOFJSONCasted {
                    if let designer = walk["designer"],
                    let description = walk["info"],
                    let location = walk["location"],
                    let sketch = walk["sketch_by_designer"] {
                        walkArray.append(Walk(designer: designer, location: location, description: description, sketchURLString: sketch))
                    }
                }
                return walkArray
            }else {
                return nil
            }
            
        }catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getWalks(apiEndpoint: String, callback: @escaping([Walk]?) -> Void) {
        if let validWOFEndpoint: URL = URL(string: apiEndpoint){
            let session = URLSession(configuration: .default)
            session.dataTask(with: validWOFEndpoint){ (data:Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("Error encountered!: \(error!)")
                }
                if let validData: Data = data{
                    print(validData)
                    if let allTheWals: [Walk] = self.getWalks(fromInDictionary: validData) {
                        callback(allTheWals)
                    }
                }
            }.resume()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWOF = self.walks[indexPath.row]
        performSegue(withIdentifier: "wofDetailViewSegue", sender: selectedWOF)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wofDetailViewSegue" {
            let detailViewController = segue.destination as? WOFDetailViewController
            let selectedWOF = sender as? Walk
            detailViewController?.wof = selectedWOF
        }
    }


    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
