//
//  LoggingFormViewController.swift
//  speedo
//
//  Created by Marcus Milne on 12/9/21.
//

import SwiftUI
import UIKit

class LoggingFormViewController: UIViewController {

    var mainView: ViewController?
    var childView: UIHostingController<LoggingForm>?
    var wheelDrive: Int = 4
    var wheelSize: Int = 160
    var batteryLevel = 0
    
    @IBOutlet var container: UIView!
    
    func btnStart() {
        Global.insertLog(wheelDrive: wheelDrive, wheelSize: wheelSize, battery: batteryLevel)
        mainView?.startLogging()
        dismiss(animated: true, completion: nil)
    }
    
    func btnCancel() {
        dismiss(animated: true, completion: nil)
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
        if (text != "") {
            batteryLevel = Int(text)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        childView = UIHostingController(rootView: LoggingForm(
            callbackStart: self.btnStart,
            callbackCancel: self.btnCancel,
            setWheelDrive: setWheelDrive(text:),
            setWheelSize: setWheelSize(text:),
            setBatteryLevel: setBatteryLevel(text:))
        )
        addChild(childView!)
        childView!.view.frame = container.bounds
        container.addSubview(childView!.view)
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
