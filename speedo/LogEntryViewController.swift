//
//  LogEntryViewController.swift
//  speedo
//
//  Created by Marcus Milne on 13/9/21.
//

import SwiftUI
import CoreData
import UIKit

class LogEntryViewController: UIViewController {

    @IBOutlet var container: UIView!
    var DBMOlog: NSManagedObject?
    var childView: UIHostingController<LogEntryForm>?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(DBMOlog)
        childView = UIHostingController(rootView: LogEntryForm())
        addChild(childView!)
        childView!.view.frame = container.bounds
        container.addSubview(childView!.view)
        container.sendSubviewToBack(childView!.view)
        childView!.didMove(toParent: self)

    }
    
    @IBAction func pressedDone(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
