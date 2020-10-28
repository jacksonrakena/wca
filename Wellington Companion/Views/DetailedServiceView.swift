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
        Text(service.route)
    }
}
