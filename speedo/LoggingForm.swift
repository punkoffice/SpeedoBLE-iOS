//
//  LoggingForm.swift
//  speedo
//
//  Created by Marcus Milne on 12/9/21.
//

import SwiftUI

enum wheelDriveOptions: String, CaseIterable, Identifiable {
    case wd2
    case wd4
    var id: String { self.rawValue }
}

enum wheelSizeOptions: String, CaseIterable, Identifiable {
    case mm120
    case mm160
    case mm175
    var id: String { self.rawValue}
}

struct LoggingForm: View {
    var setWheelDrive: (String) -> Void
    var setWheelSize: (String) -> Void
    var setBatteryLevel: (String) -> Void
    @State var keyboardVisible = false
    @State var wheelDrive: wheelDriveOptions = .wd4
    @State var wheelSize: wheelSizeOptions = .mm160
    @State var batteryLevel: String = ""
    var body: some View {
        NavigationView {
            Form {
                Picker("Wheel drive", selection: $wheelDrive) {
                    Text("2WD").tag(wheelDriveOptions.wd2)
                    Text("4WD").tag(wheelDriveOptions.wd4)
                }.onChange(of: wheelDrive) { _ in
                    setWheelDrive(wheelDrive.rawValue)
                }
                Picker("Wheel size", selection: $wheelSize) {
                    Text("120mm").tag(wheelSizeOptions.mm120)
                    Text("160mm").tag(wheelSizeOptions.mm160)
                    Text("175mm").tag(wheelSizeOptions.mm175)
                }.onChange(of: wheelSize) { _ in
                    setWheelSize(wheelSize.rawValue)
                }
                TextField("Battery level", text: $batteryLevel).keyboardType(.numberPad).onChange(of: batteryLevel) { _ in
                    setBatteryLevel(batteryLevel)
                }
            }
            .navigationBarTitle("Board Details")
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}
