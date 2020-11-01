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
        self.timeRecorded = Constants.metlinkDateFormatter.date(from: raw.RecordedAtTime)
        self.notice = raw.LineNote
    }
}

enum DepartureStatus {
    case delayed
    case onTime
    case unknown
    
    func toString() -> String {
        switch self {
        case .delayed:
            return "Delayed"
        case .onTime:
            return "On time"
        case .unknown:
            return "Unknown"
        }
    }
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
    public var routeLongName: String
    public var raw: MetlinkStopServiceObject
    
    public var isTrainService: Bool = false
    public var trainServiceType: String?
    
    init(raw: MetlinkStopServiceObject) {
        self.raw = raw
        self.route = raw.ServiceID ?? "Unknown"
        self.originStopId = raw.OriginStopID ?? "Unknown"
        self.destinationStopId = raw.DestinationStopID ?? "Unknown"
        self.originStopName = raw.OriginStopName ?? "Unknown"
        self.destinationStopName = raw.DestinationStopName ?? "Unknown"
        self.routeLongName = raw.Service.Name ?? "Unknown"
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
        
        let split = self.destinationStopName.split(separator: "-")
        if split.count > 1 && split[0].count == 4 {
            isTrainService = true
            self.destinationStopName = String(split[0])
            self.trainServiceType = String(split[1])
        }
    }
}

struct StopInfo: Identifiable {
    var id: String { get {
        return stopName
    }}
    public var stopName: String
    public var stopSubtitle: String?
    public var fareZone: String
    public var stopId: String
    public var notices: [StopNotice]
    public var upcomingServices: [StopService]
    public var latitude, longitude: Double?
    
    public var longStopName: String { get {
        if self.stopSubtitle != nil {
            return self.stopName + " - " + self.stopSubtitle!
        }
        return self.stopName
    }}
    
    init(raw: MetlinkStopDeparturesResponse) {
        self.stopName = raw.Stop.Name ?? "Unknown"
        self.fareZone = raw.Stop.Farezone ?? "Unknown"
        self.stopId = raw.Stop.Sms ?? "Unknown"
        if raw.Notices != nil {
            self.notices = raw.Notices!.map({ (stopNotice) -> StopNotice in
                return StopNotice(raw: stopNotice)
            })
        } else {
            self.notices = []
        }
        
        if raw.Services != nil {
            self.upcomingServices = raw.Services!.map({ (service) -> StopService in
                return StopService(raw: service)
            })
        } else {
            self.upcomingServices = []
        }
        
        self.latitude = raw.Stop.Lat
        self.longitude = raw.Stop.Long
        
        var stopNameSplit = self.stopName.split(separator: "-")
        if stopNameSplit.count > 1 {
            self.stopName = stopNameSplit[0].trimmingCharacters(in: CharacterSet.whitespaces)
            self.stopSubtitle = stopNameSplit[1].trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
}
