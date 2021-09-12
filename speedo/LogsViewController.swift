//
//  LogsViewController.swift
//  speedo
//
//  Created by Marcus Milne on 12/9/21.
//

import CoreData
import UIKit

class LogsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Global.DBitemsLogs!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let DBMOlog = Global.DBitemsLogs![indexPath.row] as? NSManagedObject
        let datetime = DBMOlog!.value(forKey: "datetime") as! Date
        let topSpeed = DBMOlog!.value(forKey: "topSpeed") as! Int
        let distance = DBMOlog!.value(forKey: "distance") as! Int
        let duration = DBMOlog!.value(forKey: "duration") as! Int
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath)
        let lblDateTime = cell.viewWithTag(1) as? UILabel
        let lblTopSpeed = cell.viewWithTag(2) as? UILabel
        let lblDistance = cell.viewWithTag(3) as? UILabel
        let lblDuration = cell.viewWithTag(4) as? UILabel
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDateTime = dateFormatter.string(from: datetime)
        lblDateTime?.text = strDateTime
        lblTopSpeed?.text = topSpeed.description
        let dblDistance = Double(distance)/1000.0
        lblDistance?.text =  String(format: "%.1f", dblDistance)
        lblDuration?.text = duration.description
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
