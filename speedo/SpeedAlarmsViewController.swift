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
            let rowIdx = sender.row!
            let intSpeed = Int(sender.text!) ?? 0
            if (showEmptySpeedAlarmsCount && rowIdx == tableView.numberOfRows(inSection: 0)-2) {
                showEmptySpeedAlarmsCount = false
                Global.insertSpeedAlarm(speed: intSpeed)
            } else {
                Global.changeSpeedAlarm(speed: intSpeed, index: rowIdx)
            }
        }
    }
    
    @objc func deleteRow(sender: extUIButton) {
        let rowIdx = sender.row!
        let idxPath = IndexPath(row: rowIdx, section: 0)
        if (showEmptySpeedAlarmsCount && rowIdx == tableView.numberOfRows(inSection: 0)-2) {
            showEmptySpeedAlarmsCount = false
            self.tableView.deleteRows(at: [idxPath], with: UITableView.RowAnimation.automatic)
        } else {
            Global.removeSpeedAlarm(index: rowIdx)
            self.tableView.deleteRows(at: [idxPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    @objc func resetAlarms() {
        Global.rebuildSpeedAlarmList()
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
                let btnDelete = cell.viewWithTag(2) as! extUIButton
                txtSpeed.row = indexPath.row
                txtSpeed.addTarget(self, action: #selector(saveSpeed), for: .editingChanged)
                btnDelete.row = indexPath.row
                btnDelete.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "cellSpeed", for: indexPath)
                let txtSpeed = cell.viewWithTag(1) as! extUITextField
                let btnDelete = cell.viewWithTag(2) as! extUIButton
                let DBMOspeed = Global.DBitemsSpeed![indexPath.row] as? NSManagedObject
                let intSpeed = DBMOspeed!.value(forKey: "speed") as! Int
                txtSpeed.row = indexPath.row
                txtSpeed.text! = intSpeed.description
                txtSpeed.addTarget(self, action: #selector(saveSpeed), for: .editingChanged)
                btnDelete.row = indexPath.row
                btnDelete.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
            }
        } else if (indexPath.row == tableView.numberOfRows(inSection: 0)-1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellLast", for: indexPath)
            let btnAdd = cell.viewWithTag(5) as! UIButton
            let btnDone = cell.viewWithTag(6) as! UIButton
            let btnReset = cell.viewWithTag(7) as! UIButton
            btnAdd.addTarget(self, action: #selector(addSpeedRow), for: .touchUpInside)
            btnDone.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
            btnReset.addTarget(self, action: #selector(resetAlarms), for: .touchUpInside)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellSpeed", for: indexPath)
            let txtSpeed = cell.viewWithTag(1) as! extUITextField
            let DBMOspeed = Global.DBitemsSpeed![indexPath.row] as? NSManagedObject
            let intSpeed = DBMOspeed!.value(forKey: "speed") as! Int
            let btnDelete = cell.viewWithTag(2) as! extUIButton
            txtSpeed.row = indexPath.row
            txtSpeed.text! = intSpeed.description
            txtSpeed.addTarget(self, action: #selector(saveSpeed), for: .editingChanged)
            btnDelete.row = indexPath.row
            btnDelete.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77.0
    }
}

class extUITextField: UITextField {
    var row: Int?
}

class extUIButton: UIButton {
    var row: Int?
}
