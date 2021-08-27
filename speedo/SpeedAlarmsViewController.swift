//
//  SpeedAlarmsViewController.swift
//  speedo
//
//  Created by Marcus Milne on 26/8/21.
//

import UIKit
import CoreData

class SpeedAlarmsViewController: UITableViewController {

    var showEmptySpeedAlarmsCount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
    }

    @objc func addSpeedRow() {
        showEmptySpeedAlarmsCount = true
        self.tableView.reloadData()
    }
    
    @objc func saveSpeed(sender: extUITextField) {
        if (sender.text != nil) {
            let rowIdx = sender.indexPath!
            let intSpeed = Int(sender.text!) ?? 0
            if (showEmptySpeedAlarmsCount && rowIdx == tableView.numberOfRows(inSection: 0)-2) {
                showEmptySpeedAlarmsCount = false
                Global.insertSpeedAlarm(speed: intSpeed)
            } else {
                Global.changeSpeedAlarm(speed: intSpeed, index: rowIdx)
            }
        }
    }
    
    @objc func deleteRow() {
        print("Delete row")
    }
    
    @objc func closeViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowCount = 1
        if (showEmptySpeedAlarmsCount) {
            rowCount += 1
        }
        if (Global.DBitemsSpeed != nil) {
            rowCount += Global.DBitemsSpeed!.count
        }
        return rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if (indexPath.row == tableView.numberOfRows(inSection: 0)-2) {
            if (showEmptySpeedAlarmsCount) {
                cell = tableView.dequeueReusableCell(withIdentifier: "cellSpeed", for: indexPath)
                let txtSpeed = cell.viewWithTag(1) as! extUITextField
                let btnDelete = cell.viewWithTag(2) as! UIButton
                txtSpeed.indexPath = indexPath.row
                txtSpeed.addTarget(self, action: #selector(saveSpeed), for: .editingChanged)
                btnDelete.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "cellSpeed", for: indexPath)
                let txtSpeed = cell.viewWithTag(1) as! extUITextField
                let btnDelete = cell.viewWithTag(2) as! UIButton
                let DBMOspeed = Global.DBitemsSpeed![indexPath.row] as? NSManagedObject
                let intSpeed = DBMOspeed!.value(forKey: "speed") as! Int
                txtSpeed.indexPath = indexPath.row
                txtSpeed.text! = intSpeed.description
                txtSpeed.addTarget(self, action: #selector(saveSpeed), for: .editingChanged)
                btnDelete.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
            }
        } else if (indexPath.row == tableView.numberOfRows(inSection: 0)-1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellLast", for: indexPath)
            let btnAdd = cell.viewWithTag(5) as! UIButton
            let btnDone = cell.viewWithTag(6) as! UIButton
            btnAdd.addTarget(self, action: #selector(addSpeedRow), for: .touchUpInside)
            btnDone.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellSpeed", for: indexPath)
            let txtSpeed = cell.viewWithTag(1) as! extUITextField
            let DBMOspeed = Global.DBitemsSpeed![indexPath.row] as? NSManagedObject
            let intSpeed = DBMOspeed!.value(forKey: "speed") as! Int
            let btnDelete = cell.viewWithTag(2) as! UIButton
            txtSpeed.indexPath = indexPath.row
            txtSpeed.text! = intSpeed.description
            txtSpeed.addTarget(self, action: #selector(saveSpeed), for: .editingChanged)
            btnDelete.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77.0
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

class extUITextField: UITextField {
    var indexPath: Int?
}
