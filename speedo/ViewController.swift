//
//  ViewController.swift
//  speedo
//
//  Created by Marcus Milne on 29/7/21.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblConnected: UILabel!
    @IBOutlet weak var lblLat: UILabel!
    @IBOutlet weak var lblLong: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    
    @IBOutlet weak var txtWatchyName: UITextField!
    @IBOutlet weak var txtSpeedFilter: UITextField!
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var bleSpeed: CBCharacteristic!
    private var bleTime: CBCharacteristic!
    private var bleAlarm: CBCharacteristic!
    private let locationManager = LocationManager.shared
    private var isConnected = false
    private var testTimer: Timer!
    private var testCurrentSpeed = 3
    private var maxSpeed = 0
    private var totalDistance = 0
    private var lastLocation: CLLocation?
    private var lastTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        txtWatchyName.text = Global.watchyName
        txtSpeedFilter.text = Global.speedFilter.description
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.txtWatchyName.delegate = self
        self.txtSpeedFilter.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLocationUpdates()
    }
    
    @IBAction func tappedView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segSpeedAlarms") {
            let svc = segue.destination as? SpeedAlarmsViewController
            svc?.modalPresentationStyle = .fullScreen
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    private func checkSpeedAlarm(speed: Int) {
        if (Global.orderedSpeed!.count > 0) {
            if (Global.speedIdx < Global.orderedSpeed!.count) {
                let currentAlarm = Global.orderedSpeed![Global.speedIdx] as! Int
                if (speed >= currentAlarm) {
                    Global.pastThresholdCount += 1
                } else {
                    Global.pastThresholdCount = 0
                }
                if (Global.pastThresholdCount > 2) {
                    print("ALARM ",Global.speedIdx)
                    if (self.bleAlarm != nil) {
                        self.peripheral.writeValue(currentAlarm.description.data(using: .utf8)!, for: self.bleAlarm, type: .withResponse)
                    }
                    Global.speedIdx += 1
                    Global.pastThresholdCount = 0
                }
            }
        }
    }
    
    @objc private func testUpdate() {
        if (isConnected) {
            //let speed = Int.random(in: 1...30)
            let speed = testCurrentSpeed
            let distanceInMetres = 200
            totalDistance += distanceInMetres
            let distanceKs = Double(totalDistance) / 1000.0
            let strTotalKs = String(format: "%.1f", distanceKs)
            let combinedString = speed.description + ":" + distanceInMetres.description
            peripheral.writeValue(combinedString.description.data(using: .utf8)!, for: self.bleSpeed, type: .withResponse)
            testCurrentSpeed += 1
            checkSpeedAlarm(speed: speed)
        }
    }
    
    private func startTests() {
        testTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(testUpdate), userInfo: nil, repeats: true)
    }
    
    private func sendTime() {
        let date = Date()
        let calendar = Calendar.current
        let calYear = calendar.component(.year, from: date)
        let calMonth = calendar.component(.month, from: date)
        let calDate = calendar.component(.day, from: date)
        let calHour = calendar.component(.hour, from: date)
        let calMinutes = calendar.component(.minute, from: date)
        let calSeconds = calendar.component(.second, from: date)
        var strDateTime = calYear.description + ":"
        strDateTime += calMonth.description + ":"
        strDateTime += calDate.description + ":"
        strDateTime += calHour.description + ":"
        strDateTime += calMinutes.description + ":"
        strDateTime += calSeconds.description
        peripheral.writeValue(strDateTime.data(using: .utf8)!, for: self.bleTime, type: .withResponse)
    }
    
    func updateSettings() {
        print("Updaing settings...")
    }
    
    @IBAction func changedWatchyName(_ sender: UITextField) {
        if (sender.text == nil) {
            Global.watchyName = ""
        } else {
            Global.watchyName = sender.text!
        }
        Global.saveSettings(data: Global.watchyName, key: "watchyName")
    }
    
    @IBAction func changedSpeedFilter(_ sender: UITextField) {
        if (sender.text == nil) {
            Global.speedFilter = 0
        } else {
            let intSpeedFilter = Int(sender.text!)
            if (intSpeedFilter == nil) {
                Global.speedFilter = 0
            } else {
                Global.speedFilter = intSpeedFilter!
            }
        }
        Global.saveSettings(data: Global.speedFilter, key: "speedFilter")
    }
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning...")
        }
    }
  
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.isConnected = false
        testTimer.invalidate()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (peripheral.name != nil) {
            print("Name: ",peripheral.name!)
            if peripheral.name! == "Watchy Speedo" {
                print("Sensor Found!")
                lblConnected.isHidden = false
                centralManager.stopScan()
                
                //connect
                centralManager.connect(peripheral, options: nil)
                self.isConnected = true
                self.peripheral = peripheral
                Global.peripheral = peripheral
                self.peripheral.delegate = self
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral)
        if let services = peripheral.services {
            //discover characteristics of services
            for service in services {
                print(service)
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
}

extension ViewController: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let speedoUUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
        let timeUUID = "AD0794BA-F0DC-11EB-9A03-0242AC130003"
        let alarmUUID = "DC4F89AF-C7D6-48B3-B713-43B4E835C965"
        if let charac = service.characteristics {
            for characteristic in charac {
                //MARK:- Light Value
                if characteristic.uuid.description == speedoUUID {
                    self.bleSpeed = characteristic
                    #if FAKEGPS
                        startTests()
                    #endif
                } else if characteristic.uuid.description == timeUUID {
                    self.bleTime = characteristic
                    Global.bleTime = characteristic
                    sendTime()
                } else if characteristic.uuid.description == alarmUUID {
                    self.bleAlarm = characteristic
                }
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        guard newLocation.horizontalAccuracy < 10 else { return }
        if (lastLocation == nil) {
            lastLocation = newLocation
        } else {
            let distanceInMetres = newLocation.distance(from: lastLocation!)
            totalDistance += Int(distanceInMetres)
            let distanceKs = Double(totalDistance) / 1000.0
            let strTotalKs = String(format: "%.1f", distanceKs)
            let kph = max(newLocation.speed * 3.6, 0)
            let wholeSpeed = Int(round(kph))
            if (wholeSpeed < Global.speedFilter) {
                lblLat.text = String(format: "%.4f", newLocation.coordinate.latitude)
                lblLong.text = String(format: "%.4f", newLocation.coordinate.longitude)
                lblSpeed.text = wholeSpeed.description
                let combinedString = wholeSpeed.description + ":" + distanceInMetres.description
                if (isConnected) {
                    if (self.bleSpeed != nil) {
                        #if !FAKEGPS
                            self.checkSpeedAlarm(speed: wholeSpeed)
                            self.peripheral.writeValue(combinedString.data(using: .utf8)!, for: self.bleSpeed, type: .withResponse)
                        #endif
                    }
                }
            }
            lastLocation = newLocation
            lastTime = newLocation.timestamp
        }
    }
}
