//
//  AddStopView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI
import CoreData

struct AddStopView: View {
    @State var id: String = ""
    @EnvironmentObject var apiManager: ApiManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            AllStopsMapView().padding()
            Text("Type in a stop ID from the map above:").bold()
            HStack {
                TextField("", text: $id).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 100, height: nil, alignment: .center)
                Button("Add") {
                    apiManager.addStop(id: id)
                    presentationMode.wrappedValue.dismiss()
                }
            }.padding()
        }.navigationBarTitle("Add a stop")
    }
}
