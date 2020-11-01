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
        NavigationLink(destination: NavigationLazyView(StopDetailView(stop: stop))) {
            VStack(alignment: .leading, spacing: nil) {
                if stop.stopSubtitle != nil {
                    HStack {
                        Text(stop.stopName)
                        //Spacer()
                        Text(stop.stopSubtitle!).foregroundColor(.gray)
                    }
                } else {
                    Text(stop.stopName)
                }
                HStack(alignment: .center, spacing: 0) {
                    if stop.upcomingServices.count > 1 {
                        NextArrivalSneakView(color: .yellow, service: stop.upcomingServices[0]).frame(minWidth: 0, maxWidth: .infinity)
                        
                        NextArrivalSneakView(color: .yellow, service: stop.upcomingServices[1]).frame(minWidth: 0, maxWidth: .infinity)
                        
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
        VStack(alignment: .leading, spacing: nil) {
            HStack(alignment: VerticalAlignment.center) {
                Text(service.route)
                    .font(.system(size: 11))
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 25).fill(color), alignment: .center)
                VStack(alignment: .leading) {
                    Text(Utils.getServiceDestination(for: service)).font(.system(size: 13))
                    Text(Utils.getServiceTime(for: service)).font(.system(size: 13)).foregroundColor(.gray)
                }
                /*Text(service.destinationStopName + " - " + Utils.getServiceTime(for: service)).font(.system(size: 13))*/
                Spacer()
            }
        }
    }
}
