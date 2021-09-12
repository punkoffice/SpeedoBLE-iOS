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
    var wheelDrive: String?
    var wheelSize: String?
    var batteryLevel: Int?
    
    @IBOutlet var container: UIView!
    @IBAction func pressedStart(_ sender: UIButton) {
        mainView?.startLogging()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func btnStart() {
        mainView?.startLogging()
        dismiss(animated: true, completion: nil)
    }
    
    func btnCancel() {
        dismiss(animated: true, completion: nil)
    }

    func setWheelDrive(text: String) {
        wheelDrive = text
    }
    
    func setWheelSize(text: String) {
        wheelSize = text
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
