//
//  BusAndTrainView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI

struct BusAndTrainView: View {
    @EnvironmentObject var apiManager: ApiManager
    
    var body: some View {
        NavigationView {
            VStack {
                if (apiManager.quickStopLoadError != "") {
                    Text(apiManager.quickStopLoadError).padding()
                }
                else {
                    List {
                        ForEach(apiManager.stops.sorted(by: { i0, i1 in
                            return i0.stopName < i1.stopName
                        })) { (stopinfo) in
                            StopNavigationLink(stop: stopinfo)
                        }.onDelete { index in
                            let stops = try! PersistenceController.shared.container.viewContext.fetch(SavedStop.fetchRequest()) as [SavedStop]
                            for i in index {
                                let stop = apiManager.stops[i]
                                let toDelete = stops.first {
                                    stop.stopId == $0.stopId
                                }
                                if toDelete != nil {
                                    apiManager.stops.remove(at: i)
                                    PersistenceController.shared.container.viewContext.delete(toDelete!)
                                    try! PersistenceController.shared.container.viewContext.save()
                                }
                            }
                        }
                        NavigationLink(destination: AddStopView().environmentObject(apiManager)) {
                            Text("Add a stop").foregroundColor(.blue)
                        }
                    }
                }
            }.navigationBarTitle("Your favourite stops").navigationBarItems(trailing: Button("Refresh") {
                self.apiManager.updateQuickStopView()
            })
        }
    }
}
