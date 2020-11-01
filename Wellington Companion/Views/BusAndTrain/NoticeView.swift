//
//  NoticeView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 29/Oct/20.
//

import SwiftUI

struct NoticeView: View {
    var stop: StopInfo
    var notices: [StopNotice]
    var body: some View {
        NavigationView {
            VStack {
                Text("Notices for Stop " + stop.stopId).bold()
                Text(stop.longStopName).foregroundColor(.gray)
                List {
                    ForEach(notices) { notice in
                        VStack {
                            HStack {
                                Text(notice.timeRecorded!.asLongDateString()).bold()
                            }
                            Text(notice.notice)
                        }
                    }
                }
            }
        }.navigationBarTitle("Notices")
    }
}
