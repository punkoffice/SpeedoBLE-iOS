//
//  LogEntryForm.swift
//  speedo
//
//  Created by Marcus Milne on 13/9/21.
//

import SwiftUI

struct LogEntryForm: View {
    var setWheelDrive: (String) -> Void
    var setWheelSize: (String) -> Void
    var setBatteryStart: (String) -> Double
    var setBatteryEnd: (String) -> Double
    var datetime: String
    var pWheelDrive: Int
    var pWheelSize: Int
    var pTopSpeed: Int
    var pBatteryStart: Int
    var pBatteryEnd: Int
    var pDistance: Int
    var pDuration: Int
    var pPotentialDistance: Double
    @State var wheelDrive: wheelDriveOptions = .wd4
    @State var wheelSize: wheelSizeOptions = .mm160
    @State var batteryStart: String = ""
    @State var batteryEnd: String = ""
    @State var potentialDistance: String = ""
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Time")
                    Spacer()
                    Text(datetime)
                }
                Picker("Wheel drive", selection: $wheelDrive) {
                    Text("2WD").tag(wheelDriveOptions.wd2)
                    Text("4WD").tag(wheelDriveOptions.wd4)
                }.onAppear() {
                    if (pWheelDrive == 2) {
                        wheelDrive = .wd2
                    } else {
                        wheelDrive = .wd4
                    }
                }.onChange(of: wheelDrive) { _ in
                    setWheelDrive(wheelDrive.rawValue)
                }
                Picker("Wheel size", selection: $wheelSize) {
                    Text("120mm").tag(wheelSizeOptions.mm120)
                    Text("160mm").tag(wheelSizeOptions.mm160)
                    Text("175mm").tag(wheelSizeOptions.mm175)
                }.onAppear() {
                    if (pWheelSize == 120) {
                        wheelSize = .mm120
                    } else if (pWheelSize == 160) {
                        wheelSize = .mm160
                    } else {
                        wheelSize = .mm175
                    }
                }.onChange(of: wheelSize) { _ in
                    setWheelSize(wheelSize.rawValue)
                }
                HStack {
                    Text("Top speed")
                    Spacer()
                    Text(pTopSpeed.description+" KPH")
                }
                HStack {
                    Text("Duration")
                    Spacer()
                    Text(pDuration.description+" minutes")
                }
                HStack {
                    Text("Battery start")
                    Spacer()
                    TextField("", text: $batteryStart).onAppear() {
                        if (pBatteryStart == -1) {
                            batteryStart = ""
                        } else {
                            batteryStart = pBatteryStart.description
                        }
                    }.keyboardType(.numberPad).foregroundColor(Color.gray).frame(minWidth: 60, maxWidth: 60, alignment: .leading).onChange(of: batteryStart) { _ in
                        let dblPotentialDistance = setBatteryStart(batteryStart)
                        if (dblPotentialDistance < 0) {
                            self.potentialDistance = ""
                        } else {
                            self.potentialDistance = String(format: "%.1f",Double(dblPotentialDistance)/1000.0)+" Ks"
                        }
                    }
                }
                HStack {
                    Text("Battery end")
                    Spacer()
                    TextField("", text: $batteryEnd).onAppear() {
                        if (pBatteryEnd == -1) {
                            batteryEnd = ""
                        } else {
                            batteryEnd = pBatteryEnd.description
                        }
                    }.keyboardType(.numberPad).foregroundColor(Color.gray).frame(minWidth: 60, maxWidth: 60, alignment: .leading).onChange(of: batteryEnd) { _ in
                        let dblPotentialDistance = setBatteryEnd(batteryEnd)
                        if (dblPotentialDistance < 0) {
                            self.potentialDistance = ""
                        } else {
                            self.potentialDistance = String(format: "%.1f",Double(dblPotentialDistance)/1000.0)+" Ks"
                        }
                    }
                }
                HStack {
                    Text("Distance")
                    Spacer()
                    Text(String(format: "%.1f",Double(pDistance)/1000.0)+" Ks")
                }
                HStack {
                    Text("Potential distance")
                    Spacer()
                    Text(self.potentialDistance)
                }
            }
            .navigationBarTitle("Log Entry")
        }
    }
}

