//
//  WalkOfFameTableViewController.swift
//  throwAway
//
//  Created by C4Q on 10/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class WalkOfFameTableViewController: UITableViewController {
    
    var walkData = [Walk]()
    var walkData2 = [Walk]()
    
    internal let walkJSONFileName: String = "walkoffame.json"
    internal let walkURL: String = "https://data.cityofnewyork.us/resource/btth-hrxi.json"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        //        guard let walkURL: URL = self.getResourceURL(from: walkJSONFileName),
        //            let walkData: Data = self.getData(from: walkURL),
        //            let walkAll: [Walk] = self.getWalk(from: walkData) else { return }
        //
        //        self.walkData = walkAll
        
        self.getDesiigners(apiEndpoint: walkURL) { (walkArr: [Walk]?) in
            if let walks = walkArr {
                self.walkData2 = walks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        return walkData2.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walkfOfFameCell", for: indexPath)
        let currentWalk = walkData2[indexPath.row]
        
        cell.textLabel?.text = currentWalk.designer
        cell.detailTextLabel?.text = currentWalk.location
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegueID" {
            let dvc = segue.destination as? DetailViewController
            
            let cell = sender as? UITableViewCell
            
            let cellIndex = self.tableView.indexPath(for: cell!)!
            
            dvc?.textDotText = walkData2[cellIndex.row].description
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Data
    
    func loadData() {
        guard let path = Bundle.main.path(forResource: "walkoffame", ofType: "json") ,
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options:  NSData.ReadingOptions.mappedIfSafe),
            let dict = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary else {
                return
        }
        
        if let walkArr = dict?.value(forKeyPath: "data") as? [[Any]] {
            for walk in walkArr {
                if let wlk = Walk.init(withArray: walk) {
                    self.walkData.append(wlk)
                }
            }
        }
    }
    
    
    func getDesiigners(apiEndpoint: String, callback: @escaping ([Walk]?) -> Void) {
        if let validURL = URL(string: apiEndpoint) {
            let session = URLSession(configuration: .default)
            
            session.dataTask(with: validURL) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("Error encountered: \(error)")
                }
                if let validData = data {
                    
                    let arr = self.getDesiigners(withData: validData)
                    callback(arr)
                }
                }.resume()
        }
        
    }
    
    
    func getDesiigners(withData: Data) -> [Walk] {
        var arr = [Walk]()
        
        
        do {
            let walkData: Any = try JSONSerialization.jsonObject(with: withData, options: [])
            if let walkArr = walkData as? [[String:String]] {
                for walkDict in walkArr {
                    if let w = Walk(withDict: walkDict) {
                        arr.append(w)
                    }
                }
            }
        }
            
        catch let error as NSError {
            print("Error occurred while pasing data: \(error.localizedDescription)")
        }
        print("Function Array Count \(arr.count)")
        
        
        return arr
    }
    //    internal func getResourceURL(from fileName: String) -> URL? {
    //
    //        // 1. There are many ways of doing this parsing, we're going to practice String traversal
    //        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
    //            return nil
    //        }
    //
    //        // 2. The upperbound of a range represents the position following the last position in the range, thus we can use it
    //        // to effectively "skip" the "." for the extension range
    //        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
    //        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
    //
    //        // 3. Here is where Bundle.main comes into play
    //        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
    //
    //        return fileURL
    //    }
    //
    //    internal func getData(from url: URL) -> Data? {
    //
    //        let fileData: Data? = try? Data(contentsOf: url)
    //        return fileData
    //
    //    }
    //
    //    internal func getWalk(from jsonData: Data) -> [Walk]? {
    //
    //        var walkOfFameData = [Walk]()
    //
    //        do {
    //            let walkJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
    //            if let data = walkJSONData as? [String: [Any]] {
    //                if let walkOfFameArr = data["data"] as? [[Any]] {
    //                    for walkOfFame in walkOfFameArr {
    //                        if let walk = Walk(withArray: walkOfFame) {
    //                            walkOfFameData.append(walk)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        catch let error as NSError {
    //            // JSONSerialization doc specficially says an NSError is returned if JSONSerialization.jsonObject(with:options:) fails
    //            print("Error occurred while parsing data: \(error.localizedDescription)")
    //        }
    //        return walkOfFameData
    //    }
    
    
}
