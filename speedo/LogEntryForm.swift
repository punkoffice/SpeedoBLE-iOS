//
//  LogEntryForm.swift
//  speedo
//
//  Created by Marcus Milne on 13/9/21.
//

import SwiftUI

struct LogEntryForm: View {
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Time")
                    Spacer()
                    Text("2010-10-10 13:23")
                }
                HStack {
                    Text("Wheel drive")
                    Spacer()
                    Text("4WD")
                }
                HStack {
                    Text("Wheel size")
                    Spacer()
                    Text("120mm")
                }
                HStack {
                    Text("Top speed")
                    Spacer()
                    Text("40kph")
                }
                HStack {
                    Text("Duration")
                    Spacer()
                    Text("20 minutes")
                }
                HStack {
                    Text("Battery start")
                    Spacer()
                    Text("95")
                }
                HStack {
                    Text("Battery end")
                    Spacer()
                    Text("30")
                }
                HStack {
                    Text("Distance")
                    Spacer()
                    Text("3.4ks")
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
        LogEntryForm()
    }
}
