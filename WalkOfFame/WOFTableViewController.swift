//
//  WOFTableViewController.swift
//  WalkOfFame
//
//  Created by Jason Gresh on 10/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class WOFTableViewController: UITableViewController {
	var walks = [Walk]()
	internal let walkJSONFileName: String = "walk_of_fame.json"
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let resourceURL = getResourceURL(from: "walk_of_fame", withExt: "json"),
			let data = getData(from: resourceURL),
			let walks = getWalks(from: data) {
			self.walks = walks
		}
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
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID", for: indexPath)
		
		let sorted = walks.sorted { $0.designer < $1.designer }
		
		let currentDesigner = sorted[indexPath.row]
		cell.textLabel?.text = currentDesigner.designer
		cell.detailTextLabel?.text = currentDesigner.location
		
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
	
	func getWalks(from jsonData: Data) -> [Walk]? {
		var walks = [Walk]()
		
		do {
			let walkJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
			if let walkArrayDict = walkJSONData as? [String:Any] {
				if let allWalkArray = walkArrayDict["data"] as? [[Any]] {
					for el in allWalkArray {
						if let w = Walk(withArray: el) {
							walks.append(w)
						}
					}
				}
			}
		}
			
		catch let error as NSError {
			// JSONSerialization doc specficially says an NSError is returned if JSONSerialization.jsonObject(with:options:) fails
			print("Error occurred while parsing data: \(error.localizedDescription)")
		}
		
		print("\n\n\n\nFunction Array Count \(walks.count)\n\n\n\n")
		return walks
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let sorted = walks.sorted { $0.designer < $1.designer }
		
		if let tappedWalksCell: UITableViewCell = sender as? UITableViewCell {
			if segue.identifier == "detailSegue" {
				let detailViewController: DetailViewController = segue.destination as! DetailViewController
				
				let cellIndexPath: IndexPath = self.tableView.indexPath(for: tappedWalksCell)!
				
				// Pass the selected object to the new view controller.
				detailViewController.selectedWalk = sorted[cellIndexPath.row]
			}
		}
	}
}
