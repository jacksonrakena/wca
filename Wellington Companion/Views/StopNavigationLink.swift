//
//  StopNavigationLink.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI

struct StopNavigationLink: View {
    var stop: StopInfo
    
    var body: some View {
        NavigationLink(destination: StopDetailView(stop: stop)) {
            VStack(alignment: .leading, spacing: nil) {
                Text(stop.stopName)
                HStack(alignment: .center, spacing: 0) {
                    if stop.upcomingServices.count > 1 {
                        NextArrivalSneakView(color: .yellow, service: stop.upcomingServices[0]).frame(minWidth: 0, maxWidth: .infinity)
                        
                        NextArrivalSneakView(color: .yellow, service: stop.upcomingServices[1]).frame(minWidth: 0, maxWidth: .infinity)
                        
                        Spacer()
                    } else if stop.upcomingServices.count == 1 {
                        NextArrivalSneakView(color: .yellow, service: stop.upcomingServices[0]).frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

struct NextArrivalSneakView: View {
    var color: Color
    var service: StopService
    
    var body: some View {
        HStack(alignment: VerticalAlignment.center) {
            Text(service.route)
                .font(.system(size: 12))
                .padding(3)
                .background(RoundedRectangle(cornerRadius: 25).fill(color), alignment: .center)
            Text(service.destinationStopName + " - " + Utils.getServiceTime(for: service)).font(.system(size: 14))
        }
    }
}
