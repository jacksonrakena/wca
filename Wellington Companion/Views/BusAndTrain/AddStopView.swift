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
            
        }.navigationBarTitle("Add a stop")
        TextField("Stop ID", text: $id)
        Button("Save") {
            do {
                var context = PersistenceController.shared.container.viewContext
                var ent = NSEntityDescription.insertNewObject(forEntityName: "SavedStop", into: context)
                ent.setValue(id, forKey: "stopId")
                self.presentationMode.wrappedValue.dismiss()
                try context.save()
                self.apiManager.updateQuickStopView()
            } catch {
                print("error saving")
            }
        }
    }
}
