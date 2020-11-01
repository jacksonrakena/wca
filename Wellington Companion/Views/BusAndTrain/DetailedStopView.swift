//
//  DetailedStopView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI
import AbyssalKit
import Introspect

struct StopDetailView: View {
    var stop: StopInfo
    
    @State private var tableView: UITableView?
    private func deselectRows() {
        if let tableView = tableView, let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    var body: some View {
        ScrollView {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(stop.longStopName).bold()
                    Text("Fare Zone " + stop.fareZone + " - " + Date().asTimeString()).foregroundColor(.gray)
                }
                Spacer()
                
                if stop.notices.count != 0 {
                    NavigationLink(destination: NoticeView(stop: stop, notices: stop.notices)) {
                        Text(String(stop.notices.count) + " notices")
                    }.foregroundColor(.white).padding().background(RoundedRectangle(cornerRadius: 25).fill(Color.blue))
                } else {
                    Text("No notices").foregroundColor(.gray)
                }
            }.padding([.trailing, .leading])
            
            StopMapView(stop: stop).padding().fixedSize(horizontal: true, vertical: true)
            
            //List {
                ForEach(stop.upcomingServices) { (service) in
                    VStack {
                        NavigationLink(destination: NavigationLazyView(ServiceDetailView(service: service)).onAppear {
                            deselectRows()
                        }) {
                            HStack(alignment: .center) {
                                Text(service.route)
                                    //.font(.system(size: 11))
                                    .foregroundColor(.black)
                                    .padding(4)
                                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.yellow), alignment: .center)
                                //Text(service.route + " - " + Utils.getServiceDestination(for: service))
                                Text(Utils.getServiceDestination(for: service)).foregroundColor(.black)
                                Spacer()
                                Text(Utils.getServiceTime(for: service)).foregroundColor(.black)
                            }
                        }
                    }.padding([.trailing, .leading])
                    Divider()
                }
            //}
                .introspectTableView(customize: { tableView in
                self.tableView = tableView
            })
        }.navigationBarTitle("Stop " + stop.stopId)
    }
}
