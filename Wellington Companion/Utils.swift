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
            return "due"
        } else if (service.departureTimeMinutes! > 60) {
            return service.departureTime!.asTimeString()
        }
        return String(service.departureTimeMinutes!) + "min"
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
