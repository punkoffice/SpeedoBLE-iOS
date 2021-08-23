//
//  Global.swift
//  speedo
//
//  Created by Marcus Milne on 31/7/21.
//

import CoreBluetooth
import CoreData
import Foundation

class Global {
    
    static var DBcontainer: NSPersistentContainer? = nil
    static var DBcontext: NSManagedObjectContext? = nil
    static var entSettings: NSEntityDescription? = nil
    static var watchyName: String = "Watchy Speedo"
    static var speedFilter: Int = 60
    static var DBitems: [Any]?
    static var DBMOsettings: NSManagedObject? = nil
    static var peripheral: CBPeripheral? = nil
    static var bleTime: CBCharacteristic? = nil
    
    static func setup() {
        Global.initDB()
        Global.loadSettings()
    }
    
    static func initDB() {
        Global.DBcontext = Global.DBcontainer!.viewContext
        Global.entSettings = NSEntityDescription.entity(forEntityName: "Settings", in: Global.DBcontext!)
    }
    
    static func sendDisconnectSignal() {
        if (Global.peripheral != nil) {
            if (Global.bleTime != nil) {
                Global.peripheral!.writeValue("0".data(using: .utf8)!, for: Global.bleTime!, type: .withResponse)
            }
        }
    }
    
    static func loadSettings() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do {
            DBitems = try Global.DBcontext!.fetch(fetchRequest)
            if (DBitems!.count == 0) {
                let recSettings = NSManagedObject(entity: Global.entSettings!, insertInto: Global.DBcontext)
                recSettings.setValue(watchyName, forKey: "watchyName")
                recSettings.setValue(speedFilter, forKey: "speedFilter")
                do {
                    try Global.DBcontext!.save()
                } catch {
                    print("Could not save \(error)")
                }
            } else {
                DBMOsettings = DBitems![0] as? NSManagedObject
                watchyName = DBMOsettings!.value(forKey: "watchyName") as! String
                speedFilter = DBMOsettings!.value(forKey: "speedFilter") as! Int
            }
        } catch {
            print("Could not load settings from DB")
        }
    }
    
    static func saveSettings(data: Any, key: String) {
        DBMOsettings?.setValue(data, forKey: key)
        do {
            try Global.DBcontext!.save()
        } catch {
            print("Could not save setting: \(error)")
        }
    }
}