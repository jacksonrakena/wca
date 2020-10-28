//
//  Models.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation

struct StopNotice: Identifiable {
    public var id = UUID()
    public var timeRecorded: Date?
    public var notice: String
    
    init(raw: MetlinkStopNoticeObject) {
        if (raw.RecordedAtTime != nil) {
            self.timeRecorded = Constants.metlinkDateFormatter.date(from: raw.RecordedAtTime)
        }
        self.notice = raw.LineNote
    }
}

enum DepartureStatus {
    case delayed
    case onTime
    case unknown
}

struct StopService: Identifiable {
    public var id = UUID()
    public var route: String
    public var originStopId, destinationStopId: String
    public var originStopName, destinationStopName: String
    public var departureStatus: DepartureStatus
    public var hasLowFloor: Bool
    public var departureTime: Date?
    public var departureTimeSeconds: Int?
    public var departureTimeMinutes: Int?
    public var isRealTime: Bool
    
    init(raw: MetlinkStopServiceObject) {
        self.route = raw.ServiceID ?? "Unknown"
        self.originStopId = raw.OriginStopID ?? "Unknown"
        self.destinationStopId = raw.DestinationStopID ?? "Unknown"
        self.originStopName = raw.OriginStopName ?? "Unknown"
        self.destinationStopName = raw.DestinationStopName ?? "Unknown"
        if (raw.DepartureStatus == "delayed") {
            self.departureStatus = DepartureStatus.delayed
        } else if (raw.DepartureStatus == "onTime") {
            self.departureStatus = DepartureStatus.onTime
        } else {
            self.departureStatus = DepartureStatus.unknown
        }
        
        self.isRealTime = raw.IsRealtime == true
        self.hasLowFloor = raw.VehicleFeature == "lowFloor"
        if (raw.DisplayDeparture != nil) {
            print(raw.DisplayDeparture!)
            self.departureTime = Constants.metlinkDateFormatter.date(from: raw.DisplayDeparture!)
        }
        if (raw.DisplayDepartureSeconds != nil) {
            self.departureTimeSeconds = raw.DisplayDepartureSeconds
            self.departureTimeMinutes = Int(floor(Double(self.departureTimeSeconds!)/60))
        }
    }
}

struct StopInfo: Identifiable {
    var id: String { get {
        return stopName
    }}
    public var stopName: String
    public var fareZone: String
    public var stopId: String
    public var notices: [StopNotice]
    public var upcomingServices: [StopService]
    public var latitude, longitude: Double?
    
    init(raw: MetlinkStopDeparturesResponse) {
        self.stopName = raw.Stop.Name ?? "Unknown"
        self.fareZone = raw.Stop.Farezone ?? "Unknown"
        self.stopId = raw.Stop.Sms ?? "Unknown"
        self.notices = raw.Notices.map({ (stopNotice) -> StopNotice in
            return StopNotice(raw: stopNotice)
        })
        self.upcomingServices = raw.Services.map({ (service) -> StopService in
            return StopService(raw: service)
        })
        self.latitude = raw.Stop.Lat
        self.longitude = raw.Stop.Long
    }
}
