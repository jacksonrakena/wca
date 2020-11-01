//
//  RawModels.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation

struct MetlinkStopDeparturesResponse: Decodable {
    public var LastModified: String
    public var Stop: MetlinkStopInfoObject
    public var Notices: [MetlinkStopNoticeObject]?
    public var Services: [MetlinkStopServiceObject]?
}

struct MetlinkStopServiceObject: Decodable {
    public var ServiceID, Direction, OperatorRef, OriginStopID, OriginStopName, DestinationStopID, DestinationStopName, DepartureStatus, ExpectedDeparture, DisplayDeparture: String?
    public var VehicleFeature, VehicleRef: String?
    public var AimedArrival, AimedDeparture: String?
    public var IsRealtime: Bool?
    public var DisplayDepartureSeconds: Int?
    public var Service: MetlinkStopServiceMetaObject
}

struct MetlinkStopServiceMetaObject: Decodable {
    public var Code, TrimmedCode, Name, Mode, Link: String?
}

struct MetlinkStopInfoObject: Decodable {
    public var Name, Sms, Farezone, LastModified: String?
    public var Lat, Long: Double?
}

struct MetlinkStopNoticeObject: Decodable {
    public var RecordedAtTime, MonitoringRef, LineRef, DirectionRef, LineNote: String
}
