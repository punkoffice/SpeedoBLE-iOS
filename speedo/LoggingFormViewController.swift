//
//  LoggingFormViewController.swift
//  speedo
//
//  Created by Marcus Milne on 12/9/21.
//

import UIKit

class LoggingFormViewController: UIViewController {

    var mainView: ViewController?
    
    @IBAction func pressedStart(_ sender: UIButton) {
        mainView?.startLogging()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
