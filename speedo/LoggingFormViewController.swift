//
//  LoggingFormViewController.swift
//  speedo
//
//  Created by Marcus Milne on 12/9/21.
//

import SwiftUI
import UIKit

class LoggingFormViewController: UIViewController, UIGestureRecognizerDelegate {

    var mainView: ViewController?
    var childView: UIHostingController<LoggingForm>?
    var wheelDrive: Int = 4
    var wheelSize: Int = 160
    var batteryLevel = -1
    
    @IBOutlet var container: UIView!
    
    @IBAction func pressedStart(_ sender: UIButton) {
        Global.insertLog(wheelDrive: wheelDrive, wheelSize: wheelSize, battery: batteryLevel)
        mainView?.startLogging()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedView(_ sender: UITapGestureRecognizer) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.superclass!.description() == "UITableView") {
            return true
        }
        return false
    }

    func setWheelDrive(text: String) {
        if (text == "wd2") {
            wheelDrive = 2
        } else {
            wheelDrive = 4
        }
    }
    
    func setWheelSize(text: String) {
        if (text == "mm175") {
            wheelSize = 175
        } else if (text == "mm160") {
            wheelSize = 160
        } else {
            wheelSize = 120
        }
    }
    func setBatteryLevel(text: String) {
        print("received battery level: ",text)
        if (text != "") {
            batteryLevel = Int(text)!
        } else {
            batteryLevel = -1
        }
        print("int battery level: ",batteryLevel.description)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        childView = UIHostingController(rootView: LoggingForm(
            setWheelDrive: setWheelDrive(text:),
            setWheelSize: setWheelSize(text:),
            setBatteryLevel: setBatteryLevel(text:))
        )
        addChild(childView!)
        childView!.view.frame = container.bounds
        container.addSubview(childView!.view)
        container.sendSubviewToBack(childView!.view)
        childView!.didMove(toParent: self)
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
