//
//  ContentView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 26/Oct/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var apiManager = ApiManager()
    
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
                    }
                }
                Text("This app uses information from Metlink.").font(.footnote)
                Text("Copyright (c) 2020 Jackson Rakena").font(.footnote)
            }.navigationBarTitle("Your favourite stops").navigationBarItems(trailing: Button("Refresh") {
                self.apiManager.updateQuickStopView()
            })
        }
    }
}
