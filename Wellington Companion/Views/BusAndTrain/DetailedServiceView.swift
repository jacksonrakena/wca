//
//  DetailedServiceView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI

struct ServiceDetailView: View {
    var service: StopService
    var body: some View {
        
        VStack {
            HStack {
                Text(service.route)
                    .font(.system(size: 35)).bold()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.yellow), alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                Text(service.destinationStopName)
                    .font(.system(size: 35)).bold().fixedSize(horizontal: false, vertical: true)
            }.padding().overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.yellow, lineWidth: 5))
            
            
            if (service.departureStatus == DepartureStatus.onTime) {
                Text("ON TIME").foregroundColor(.green).bold()
            } else if (service.departureStatus == DepartureStatus.delayed) {
                Text("DELAYED").foregroundColor(.red).bold()
            } else {
                Text("SCHEDULED").foregroundColor(Color.gray).bold()
            }
            
            HStack {
                VStack {
                    Text("Origin").bold()
                    Text(service.originStopName + " (" + service.originStopId + ")")
                }.padding()
                VStack {
                    Text("Destination").bold()
                    Text(service.destinationStopName + " (" + service.destinationStopId + ")")
                }
            }
            HStack {
                VStack {
                    Text("Expected departure").bold()
                    Text(service.departureTime!.asTimeString())
                }
            }.padding(.bottom)
            if (service.hasLowFloor) {
                Text("The vehicle operating this service has a low floor for wheelchair users.")
            }
        }.padding().navigationBarTitle(service.route + " - " + service.destinationStopName)
    }
}
