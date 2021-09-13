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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If there are new log entries, insert them into table
        if (Global.DBitemsLogs != nil) {
            if (Global.logCount < Global.DBitemsLogs!.count) {
                var arrIndexPaths: [IndexPath] = []
                var idx = Global.DBitemsLogs!.count - Global.logCount - 1
                for _ in Global.logCount...Global.DBitemsLogs!.count-1 {
                    let indexPath = IndexPath(row: idx, section: 0)
                    idx = idx - 1
                    arrIndexPaths.append(indexPath)
                }
                self.tableView.insertRows(at: arrIndexPaths, with: .automatic)
                Global.logCount = Global.DBitemsLogs!.count
            }
        }
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
        let totalLogEntries = Global.DBitemsLogs!.count
        let DBMOlog = Global.DBitemsLogs![totalLogEntries - indexPath.row - 1] as? NSManagedObject
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
        if totalLogEntries % 2 == 0 {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
            }
        } else {
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
            } else {
                cell.backgroundColor = UIColor.white
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "cellHeader") as UITableViewCell?
        headerView.addSubview(headerCell!)
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segLogEntry", sender: indexPath)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let totalLogEntries = Global.DBitemsLogs!.count
            Global.removeLog(index: (totalLogEntries - indexPath.row - 1))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segLogEntry") {
            let svc = segue.destination as? LogEntryViewController
            let selectedIndex = (sender as! IndexPath).row
            let totalLogEntries = Global.DBitemsLogs!.count
            svc?.DBMOlog = Global.DBitemsLogs![totalLogEntries - selectedIndex - 1] as? NSManagedObject
            svc?.modalPresentationStyle = .fullScreen
        }
    }
}
