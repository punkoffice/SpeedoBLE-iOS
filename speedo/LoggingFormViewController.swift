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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        childView = UIHostingController(rootView: LoggingForm(callbackStart: self.btnStart, callbackCancel: self.btnCancel))
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
