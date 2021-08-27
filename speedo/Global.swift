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
    static var entSpeedAlarms: NSEntityDescription? = nil
    static var watchyName: String = "Watchy Speedo"
    static var speedFilter: Int = 60
    static var DBitemsSettings: [Any]?
    static var DBitemsSpeed: [Any]?
    static var orderedSpeed: [Any]?
    static var speedIdx = 0
    static var pastThresholdCount = 0
    static var DBMOsettings: NSManagedObject? = nil
    static var peripheral: CBPeripheral? = nil
    static var bleTime: CBCharacteristic? = nil
    
    static func setup() {
        Global.initDB()
        Global.loadSettings()
        Global.loadSpeedAlarms()
        Global.rebuildSpeedAlarmList()
    }
    
    static func initDB() {
        Global.DBcontext = Global.DBcontainer!.viewContext
        Global.entSettings = NSEntityDescription.entity(forEntityName: "Settings", in: Global.DBcontext!)
        Global.entSpeedAlarms = NSEntityDescription.entity(forEntityName: "SpeedAlarms", in: Global.DBcontext!)
    }
    
    static func sendDisconnectSignal() {
        if (Global.peripheral != nil) {
            if (Global.bleTime != nil) {
                Global.peripheral!.writeValue("0".data(using: .utf8)!, for: Global.bleTime!, type: .withResponse)
            }
        }
    }
    
    static func insertSpeedAlarm(speed: Int) {
        let recSpeedAlarm = NSManagedObject(entity: Global.entSpeedAlarms!, insertInto: Global.DBcontext)
        recSpeedAlarm.setValue(speed, forKey: "speed")
        do {
            try Global.DBcontext!.save()
        } catch {
            print("Could not save speed alarm: \(error)")
        }
        DBitemsSpeed?.append(recSpeedAlarm)
        rebuildSpeedAlarmList()
    }
    
    static func rebuildSpeedAlarmList() {
        var unorderedSpeed: [Int]? = []
        orderedSpeed?.removeAll()
        if (DBitemsSpeed != nil) {
            for DBMOspeed in DBitemsSpeed! {
                unorderedSpeed?.append((DBMOspeed as AnyObject).value(forKey: "speed") as! Int)
            }
            var mutableSet = NSMutableOrderedSet(array: unorderedSpeed!).array as! [Int]
            mutableSet.sort()
            orderedSpeed = mutableSet
        }
        pastThresholdCount = 0
        speedIdx = 0
    }
    
    static func changeSpeedAlarm(speed: Int, index: Int) {
        let DBMOspeed = DBitemsSpeed![index] as? NSManagedObject
        if (DBMOspeed != nil) {
            DBMOspeed!.setValue(speed, forKey: "speed")
            do {
                try Global.DBcontext!.save()
            } catch {
                print("Could not save \(error)")
            }
        }
        rebuildSpeedAlarmList()
    }
    
    static func removeSpeedAlarm(index: Int) {
        if (DBitemsSpeed != nil) {
            let DBMOspeed = DBitemsSpeed![index] as? NSManagedObject
            if (DBMOspeed != nil) {
                Global.DBcontext?.delete(DBMOspeed!)
            }
            do {
                try Global.DBcontext!.save()
            } catch {
                print("Could not save \(error)")
            }
            DBitemsSpeed!.remove(at: index)
            rebuildSpeedAlarmList()
        }
    }

    static func loadSpeedAlarms() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SpeedAlarms")
        do {
            DBitemsSpeed = try Global.DBcontext!.fetch(fetchRequest)
            print("Speed alarms: ",DBitemsSpeed!.count)
        } catch {
            print("Could not load speed alarms from DB")
        }
    }

    static func loadSettings() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do {
            DBitemsSettings = try Global.DBcontext!.fetch(fetchRequest)
            if (DBitemsSettings!.count == 0) {
                let recSettings = NSManagedObject(entity: Global.entSettings!, insertInto: Global.DBcontext)
                recSettings.setValue(watchyName, forKey: "watchyName")
                recSettings.setValue(speedFilter, forKey: "speedFilter")
                do {
                    try Global.DBcontext!.save()
                } catch {
                    print("Could not save \(error)")
                }
            } else {
                DBMOsettings = DBitemsSettings![0] as? NSManagedObject
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
