//
//  StopMapView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI
import MapKit

struct StopMapView: UIViewRepresentable {
    
    class StopMapPosition: NSObject, MKAnnotation {
        let title: String?
        let coordinate: CLLocationCoordinate2D
        
        init (stop: StopInfo) {
            self.title = stop.longStopName
            self.coordinate = CLLocationCoordinate2D(latitude: stop.latitude!, longitude: stop.longitude!)
        }
    }
    
    var stop: StopInfo
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: stop.latitude!, longitude: stop.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.addAnnotation(StopMapPosition(stop: stop))
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
       
    }
}
