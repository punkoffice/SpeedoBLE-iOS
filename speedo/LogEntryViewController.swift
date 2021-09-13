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
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let datetime = DBMOlog?.value(forKey: "datetime") as? Date
        let strDateTime = getDateTimeString(datetime: datetime!)
        let intWheelDrive = DBMOlog?.value(forKey: "wheelDrive") as? Int
        let intWheelSize = DBMOlog?.value(forKey: "wheelSize") as? Int
        let intTopSpeed = DBMOlog?.value(forKey: "topSpeed") as? Int
        let intBatteryStart = DBMOlog?.value(forKey: "batteryStart") as? Int
        let intBatteryEnd = DBMOlog?.value(forKey: "batteryEnd") as? Int
        let intDistance = DBMOlog?.value(forKey: "distance") as? Int
        let intDuration = DBMOlog?.value(forKey: "duration") as? Int
        childView = UIHostingController(rootView: LogEntryForm(datetime: strDateTime, pWheelDrive: intWheelDrive!, pWheelSize: intWheelSize!, pTopSpeed: intTopSpeed!, pBatteryStart: intBatteryStart!, pBatteryEnd: intBatteryEnd!, pDistance: intDistance!, pDuration: intDuration!))
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
