//
//  LogEntryViewController.swift
//  speedo
//
//  Created by Marcus Milne on 13/9/21.
//

import SwiftUI
import CoreData
import UIKit

class LogEntryViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var container: UIView!
    var DBMOlog: NSManagedObject?
    var childView: UIHostingController<LogEntryForm>?
    var intBatteryStart = -1
    var intBatteryEnd = -1
    var intDistance = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        let datetime = DBMOlog?.value(forKey: "datetime") as? Date
        let strDateTime = getDateTimeString(datetime: datetime!)
        let intWheelDrive = DBMOlog?.value(forKey: "wheelDrive") as? Int
        let intWheelSize = DBMOlog?.value(forKey: "wheelSize") as? Int
        let intTopSpeed = DBMOlog?.value(forKey: "topSpeed") as? Int
        intBatteryStart = (DBMOlog?.value(forKey: "batteryStart") as? Int)!
        intBatteryEnd = (DBMOlog?.value(forKey: "batteryEnd") as? Int)!
        intDistance = (DBMOlog?.value(forKey: "distance") as? Int)!
        let intDuration = DBMOlog?.value(forKey: "duration") as? Int
        let pDist = calcPotentialDistance()
        childView = UIHostingController(rootView: LogEntryForm(
                                            setWheelDrive: setWheelDrive(text:),
                                            setWheelSize: setWheelSize(text:),
                                            setBatteryStart: setBatteryStart(text:),
                                            setBatteryEnd: setBatteryEnd(text:),
                                            datetime: strDateTime, pWheelDrive: intWheelDrive!, pWheelSize: intWheelSize!, pTopSpeed: intTopSpeed!, pBatteryStart: intBatteryStart, pBatteryEnd: intBatteryEnd, pDistance: intDistance, pDuration: intDuration!, pPotentialDistance: pDist))
        addChild(childView!)
        childView!.view.frame = container.bounds
        container.addSubview(childView!.view)
        container.sendSubviewToBack(childView!.view)
        childView!.didMove(toParent: self)
    }
    
    func getDateTimeString(datetime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm aaa"
        let stringDateTime = dateFormatter.string(from: datetime)
        return stringDateTime
    }
    
    @IBAction func tappedView(_ sender: UITapGestureRecognizer) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    @IBAction func pressedDone(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.superclass!.description() == "UITableView") {
            return true
        }
        return false
    }
    
    func updateDB(errorMsg: String) {
        do {
            try Global.DBcontext!.save()
        } catch {
            print("\(errorMsg) \(error)")
        }

    }
    
    func calcPotentialDistance() -> Double {
        if (intBatteryStart > 0 && intBatteryEnd > -1) {
            if (intBatteryStart > intBatteryEnd) {
                let batteryUsed = intBatteryStart - intBatteryEnd
                let multiplier = 100.0/Double(batteryUsed)
                let potentialDistance = Double(intDistance) * multiplier
                return potentialDistance
            }
        }
        return 0
    }
    
    func setWheelDrive(text: String) {
        if (text == "wd2") {
            DBMOlog?.setValue(2, forKey: "wheelDrive")
        } else {
            DBMOlog?.setValue(4, forKey: "wheelDrive")
        }
        updateDB(errorMsg: "Could not update wheel drive")
    }
    
    func setWheelSize(text: String) {
        if (text == "mm175") {
            DBMOlog?.setValue(175, forKey: "wheelSize")
        } else if (text == "mm160") {
            DBMOlog?.setValue(160, forKey: "wheelSize")
        } else {
            DBMOlog?.setValue(120, forKey: "wheelSize")
        }
        updateDB(errorMsg: "Could not update wheel size")
    }
    
    func setBatteryStart(text: String) -> Double {
        if (text != "") {
            intBatteryStart = Int(text)!
        } else {
            intBatteryStart = -1
        }
        DBMOlog?.setValue(intBatteryStart, forKey: "batteryStart")
        updateDB(errorMsg: "Could not update battery start level")
        let pDist = calcPotentialDistance()
        return pDist
    }

    func setBatteryEnd(text: String) -> Double {
        if (text != "") {
            intBatteryEnd = Int(text)!
        } else {
            intBatteryEnd = -1
        }
        DBMOlog?.setValue(intBatteryEnd, forKey: "batteryEnd")
        updateDB(errorMsg: "Could not update battery end level")
        let pDist = calcPotentialDistance()
        return pDist
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
