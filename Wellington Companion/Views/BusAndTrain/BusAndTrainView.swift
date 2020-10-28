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
                else if (apiManager.stops.count == 0) {
                    Text("Loading stops...")
                } else {
                    List {
                        ForEach(apiManager.stops) { (stopinfo) in
                            StopNavigationLink(stop: stopinfo)
                        }
                        NavigationLink(destination: AddStopView()) {
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
