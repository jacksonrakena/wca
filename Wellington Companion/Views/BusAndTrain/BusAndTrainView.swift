//
//  BusAndTrainView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI
import Introspect

struct BusAndTrainView: View {
    @EnvironmentObject var apiManager: ApiManager
    
    @State private var tableView: UITableView?
    private func deselectRows() {
        if let tableView = tableView, let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (apiManager.quickStopLoadError != "") {
                    Text(apiManager.quickStopLoadError).padding()
                }
                else {
                    HStack {
                        if (apiManager.erroredStops.count == 0) {
                            Text("All stops online").font(.subheadline).foregroundColor(.green)
                        } else {
                            Text(String(apiManager.erroredStops.count) + " stops failed to load").font(.subheadline).foregroundColor(.red)
                        }
                        Text("Last updated at " + apiManager.lastUpdateTime.asTimeString()).font(.subheadline)
                    }
                    List {
                        ForEach(apiManager.stops.sorted(by: { i0, i1 in
                            return i0.longStopName < i1.longStopName
                        })) { (stopinfo) in
                            StopNavigationLink(stop: stopinfo).onAppear {
                                deselectRows()
                            }
                        }.onDelete { index in
                            let stops = try! PersistenceController.shared.container.viewContext.fetch(SavedStop.fetchRequest()) as [SavedStop]
                            for i in index {
                                let stop = apiManager.stops.sorted(by: { i0, i1 in
                                    return i0.longStopName < i1.longStopName
                                })[i]
                                apiManager.stops.removeAll { (searchStop) -> Bool in
                                    return stop.stopId == searchStop.stopId
                                }
                                
                                let toDelete = stops.first {
                                    stop.stopId == $0.stopId
                                }
                                if toDelete != nil {
                                    PersistenceController.shared.container.viewContext.delete(toDelete!)
                                    try! PersistenceController.shared.container.viewContext.save()
                                }
                            }
                        }
                        NavigationLink(destination: AddStopView().environmentObject(apiManager)) {
                            Text("Add a stop").foregroundColor(.blue)
                        }
                        ForEach(apiManager.erroredStops, id: \.0) { (erroredStop) in
                            VStack(alignment: .leading) {
                                Text("Failed to load Stop " + erroredStop.0)
                                Text(erroredStop.1).foregroundColor(.red)
                            }
                        }
                    }.introspectTableView(customize: { tableView in
                        self.tableView = tableView
                    }).animation(.easeInOut)
                }
            }.navigationBarTitle("Your favourite stops").navigationBarItems(trailing: Button("Refresh") {
                self.apiManager.updateQuickStopView()
            })
        }
    }
}
