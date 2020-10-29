//
//  DetailedStopView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI

struct StopDetailView: View {
    var stop: StopInfo
    
    var body: some View {
        VStack {
            StopMapView(stop: stop).padding()
            
            NavigationLink(destination: NoticeView(notices: stop.notices)) {
                Text("View " + String(stop.notices.count) + " notices")
            }
            
            Text("Upcoming services").font(.largeTitle)
            List {
                ForEach(stop.upcomingServices) { (service) in
                    VStack {
                        NavigationLink(destination: ServiceDetailView(service: service)) {
                            HStack {
                                Text(service.route + " - " + service.destinationStopName)
                                Spacer()
                                Text(Utils.getServiceTime(for: service))
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle(stop.stopName)
    }
}
