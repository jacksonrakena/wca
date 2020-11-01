//
//  AllStopsMapView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 29/Oct/20.
//

import SwiftUI
import MapKit
import UIKit

class StoredStopInfo: NSObject, MKAnnotation {
    var stopId: String
    var stopName: String
    var stopLatitude: Double
    var stopLongitude: Double
    
    var title: String? {
        get {
            return self.stopName + " (" + self.stopId + ")"
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.stopLatitude, longitude: self.stopLongitude)
        }
    }
    
    init(stopId: String, stopName: String, stopLatitude: Double, stopLongitude: Double) {
        self.stopId = stopId
        self.stopName = stopName
        self.stopLatitude = stopLatitude
        self.stopLongitude = stopLongitude
    }
}

struct AllStopsMapView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager.shared
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func stops(data: [[String]]) -> [StoredStopInfo] {
        var result = [StoredStopInfo]()
        for row in data {
            let stop0 = StoredStopInfo(stopId: row[0], stopName: row[1], stopLatitude: Double(row[2])!, stopLongitude: Double(row[3])!)
            result.append(stop0)
        }
        return result
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        let loc = LocationManager.shared.lastLocation
        
        map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -41.2778, longitude: 174.7764), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        if let fileURL = Bundle.main.url(forResource: "stops", withExtension: "csv") {
            do {
                let contents = stops(data: csv(data: cleanRows(file: try String(contentsOf: fileURL))))
                map.addAnnotations(contents)
            } catch {
                print(error.localizedDescription)
            }
        }
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
       
    }
}
