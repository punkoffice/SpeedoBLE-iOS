//
//  LogEntryForm.swift
//  speedo
//
//  Created by Marcus Milne on 13/9/21.
//

import SwiftUI

struct LogEntryForm: View {
    var datetime: String
    var pWheelDrive: Int
    var pWheelSize: Int
    var pTopSpeed: Int
    var pBatteryStart: Int
    var pBatteryEnd: Int
    var pDistance: Int
    var pDuration: Int
    @State var wheelDrive: wheelDriveOptions = .wd4
    @State var wheelSize: wheelSizeOptions = .mm160
    @State var batteryStart: String = ""
    @State var batteryEnd: String = ""
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
                //}.onChange(of: wheelDrive) { _ in
                  //  setWheelDrive(wheelDrive.rawValue)
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
                //}.onChange(of: wheelSize) { _ in
                    //setWheelSize(wheelSize.rawValue)
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
                        batteryStart = pBatteryStart.description
                    }.keyboardType(.numberPad).foregroundColor(Color.gray).frame(minWidth: 60, maxWidth: 60, alignment: .leading)
                }
                HStack {
                    Text("Battery end")
                    Spacer()
                    TextField("", text: $batteryEnd).onAppear() {
                        batteryEnd = pBatteryEnd.description
                    }.keyboardType(.numberPad).foregroundColor(Color.gray).frame(minWidth: 60, maxWidth: 60, alignment: .leading)
                }
                HStack {
                    Text("Distance")
                    Spacer()
                    Text(String(format: "%.1f",Double(pDistance)/1000.0)+" Ks")
                }
                HStack {
                    Text("Potential distance")
                    Spacer()
                    Text("24ks")
                }
            }
            .navigationBarTitle("Log Entry")
        }
    }
}

struct LogEntryForm_Previews: PreviewProvider {
    static var previews: some View {
        LogEntryForm(datetime: "2011-10-10 13:10", pWheelDrive: 2, pWheelSize: 160, pTopSpeed: 40, pBatteryStart: 90, pBatteryEnd: 20, pDistance: 3400, pDuration: 30)
    }
}
