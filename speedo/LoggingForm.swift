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
    var callbackStart: () -> Void
    var callbackCancel: () -> Void
    var setWheelDrive: (String) -> Void
    var setWheelSize: (String) -> Void
    var setBatteryLevel: (String) -> Void
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
                TextField("Battery level", text: $batteryLevel)        .keyboardType(.numberPad).onChange(of: batteryLevel) { _ in
                    setBatteryLevel(batteryLevel)
                }
                buttons(callbackStart: callbackStart, callbackCancel: callbackCancel).padding(.top, 20).padding(.bottom, 20).buttonStyle(BorderlessButtonStyle())

            }
            .navigationBarTitle("Board Details")
        //}.onTapGesture {
           //self.endEditing()
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}

struct buttons : View {
    var callbackStart: () -> Void
    var callbackCancel: () -> Void
    var body: some View {
        HStack {
            Button(action: callbackStart) {
                HStack {
                    Spacer()
                    Text("Start")
                        .font(.headline)
                        .foregroundColor(Color.black)
                    Spacer()
                }
            }
            .padding(.vertical, 10.0)
            .background(Color.init(UIColor.lightGray))
            Spacer(minLength: 20)
            Button(action: callbackCancel) {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(Color.black)
                    Spacer()
                }
            }
            .padding(.vertical, 10.0)
            .background(Color.red)
        }
    }
}
