//
//  ContentView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 26/Oct/20.
//

import SwiftUI
import MapKit
import CoreData
import AbyssalKit

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

struct NextArrivalSneakView: View {
    var color: Color
    var service: StopService
    
    var body: some View {
        HStack(alignment: VerticalAlignment.center) {
            Text(service.route)
                .font(.system(size: 12))
                .padding(3)
                .background(RoundedRectangle(cornerRadius: 25).fill(color), alignment: .center)
            Text(service.destinationStopName + " - " + Utils.getServiceTime(for: service)).font(.system(size: 14))
        }
    }
}

struct StopMapView: UIViewRepresentable {
    class StopMapPosition: NSObject, MKAnnotation {
        let title: String?
        let coordinate: CLLocationCoordinate2D
        
        init (stop: StopInfo) {
            self.title = stop.stopName
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

struct ServiceDetailView: View {
    var service: StopService
    var body: some View {
        Text(service.route)
    }
}

struct StopDetailView: View {
    var stop: StopInfo
    
    var body: some View {
        VStack {
            StopMapView(stop: stop).padding()
            
            Text("Notices").font(.largeTitle)
            List {
                ForEach(stop.notices) { (notice) in
                    NavigationLink(destination: Text(notice.notice)) {
                        HStack {
                            Text(notice.notice).truncationMode(.tail)
                            Spacer()
                            Text(notice.timeRecorded!.string(inFormat: "MMM d"))
                        }
                    }
                }
            }
            
            Text("Upcoming services").font(.largeTitle)
            List {
                ForEach(stop.upcomingServices) { (service) in
                    VStack {
                        NavigationLink(destination: ServiceDetailView(service: service)) {
                            HStack {
                                Text(service.route + " - " + service.destinationStopName)
                                Spacer()
                                Text(Utils.getServiceTime(for: service))
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle(stop.stopName)
    }
}

struct StopSneakView: View {
    var stop: StopInfo
    
    var body: some View {
        NavigationLink(destination: StopDetailView(stop: stop)) {
            VStack(alignment: .leading, spacing: nil) {
                Text(stop.stopName)
                HStack(alignment: .center, spacing: 0) {
                    if stop.upcomingServices.count > 1 {
                        NextArrivalSneakView(color: .yellow, service: stop.upcomingServices[0]).frame(minWidth: 0, maxWidth: .infinity)
                        
                        NextArrivalSneakView(color: .yellow, service: stop.upcomingServices[1]).frame(minWidth: 0, maxWidth: .infinity)
                        
                        Spacer()
                    } else if stop.upcomingServices.count == 1 {
                        NextArrivalSneakView(color: .yellow, service: stop.upcomingServices[0]).frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            }
        }
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

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var apiManager = ApiManager()
    
    var body: some View {
        NavigationView {
            VStack {
                if (apiManager.quickStopLoadError != "") {
                    Text(apiManager.quickStopLoadError)
                }
                else if (apiManager.stops.count == 0) {
                    Text("Loading stops...")
                } else {
                    List {
                        ForEach(apiManager.stops) { (stopinfo) in
                            StopSneakView(stop: stopinfo)
                        }
                    }
                }
                Text("This app uses information from Metlink.").font(.footnote)
                Text("Copyright (c) 2020 Jackson Rakena").font(.footnote)
            }.navigationBarTitle("Your favourite stops").navigationBarItems(trailing: Button("Refresh") {
                self.apiManager.updateQuickStopView()
            })
        }
    }
}
