//
//  Utils.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import AbyssalKit
import SwiftUI

class Utils {
    static func getServiceTime(for service: StopService) -> String {
        if (service.departureTimeMinutes == 0) {
            return "Due"
        } else if (service.departureTimeMinutes! > 60) {
            return service.departureTime!.asTimeString()
        }
        return String(service.departureTimeMinutes!) + "min"
    }
    
    static func getServiceDestination(for service: StopService) -> String {
        if service.isTrainService {
            if service.trainServiceType == nil {
                return service.raw.DestinationStopName ?? "Unknown"
            }
            return service.destinationStopName + " (" + service.trainServiceType! + ")"
        }
        return service.destinationStopName
    }
}

class Constants {
    static var metlinkDateFormatter: DateFormatter {
        get {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return format
        }
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
