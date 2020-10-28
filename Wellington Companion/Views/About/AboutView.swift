//
//  AboutView.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Data").font(.title).bold()
                Text("This app uses information from Metlink, Wellington City Council (WCC), and Greater Wellington Regional Council (GWRC). Acknowledgements are made to reedwade for providing documentation for the Metlink interface.")
                
                Spacer()
                Text("Copyright").font(.title).bold()
                Text("The Wellington Companion is copyright (c) 2020 Jackson Rakena. This application is alpha software, and unauthorized usage is not permitted.")
                HStack {
                    Spacer()
                    Link("Contact", destination: URL(string: "mailto:hi@jacksonrakena.com")!).foregroundColor(.white).padding().background(RoundedRectangle(cornerRadius: 25).fill(Color.blue))
                    Spacer()
                }
                Spacer()
            }.padding().navigationBarTitle("About")
        }
    }
}
