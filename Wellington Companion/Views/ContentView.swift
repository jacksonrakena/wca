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
    let locationManager = LocationManager.shared
    
    var body: some View {
        TabView {
            BusAndTrainView().environmentObject(apiManager).tabItem {
                Image(systemName: "bus")
                Text("Bus & Train")
            }
            
            Text("Coming soon.").environmentObject(apiManager).tabItem {
                Image(systemName: "trash")
                Text("Collection")
            }
            
            Text("Coming soon.").environmentObject(apiManager).tabItem {
                Image(systemName: "ticket")
                Text("Discounts")
            }
            
            AboutView().environmentObject(apiManager).tabItem {
                Image(systemName: "info.circle")
                Text("About")
            }
        }
    }
}
