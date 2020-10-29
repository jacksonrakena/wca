//
//  NoticeView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 29/Oct/20.
//

import SwiftUI

struct NoticeView: View {
    var notices: [StopNotice]
    var body: some View {
        NavigationView {
            VStack {
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
