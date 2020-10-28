//
//  ApiManager.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 28/Oct/20.
//

import Foundation

class ApiManager: ObservableObject {
    init() {
        self.updateAll()
    }
    
    func updateAll() {
        self.updateQuickStopView()
    }
    
    @Published var isLoadingQuickStopView = true
    @Published var quickStopLoadError = ""
    @Published var stops: [StopInfo] = []
    
    func updateQuickStopView() {
        isLoadingQuickStopView = true
        quickStopLoadError = ""
        self.stops = []
        var ids = [String]()
        do {
            var fetchedIds = try PersistenceController.shared.container.viewContext.fetch(SavedStop.fetchRequest()) as [SavedStop]
            ids = fetchedIds.map { stop in
                return stop.stopId!
            }
        } catch {
            print("Error fetching saved stops")
            ids = ["7042", "7124", "5006", "5516", "4332", "WELL", "WAIK"]
        }
        for id in ids {
            ApiManager.requestStopInfo(for: id) { (info, resp, err) in
                DispatchQueue.main.async {
                    if (err != nil) {
                        print(err.debugDescription)
                        self.isLoadingQuickStopView = false
                        self.quickStopLoadError = "There was an error fetching a stop. Try again later?"
                    } else {
                        self.isLoadingQuickStopView = false
                        self.stops.append(info!)
                    }
                }
            }
        }
    }
    
    static func requestStopInfo(for stopId: String, callback: @escaping (StopInfo?, URLResponse?, Error?) -> Void) {
        ApiManager.makeWebRequest(to: URL(string: "https://metlink.org.nz/api/v1/StopDepartures/" + stopId)!, method: "GET", with: [String:Any](), using: JSONDecoder()) { (data: MetlinkStopDeparturesResponse?, response, err) in
            if (err != nil || data == nil) {
                callback(nil, response, err)
            } else {
                callback(StopInfo(raw: data!), response, err)
            }
        }
    }
    
    typealias JsonObject = [String:Any]
    
    static func makeWebRequest<T: Decodable>(to url: URL, method: String, with jsonData: JsonObject, using decoder: JSONDecoder, callback: @escaping (T?, URLResponse?, Error?) -> Void) {
            let body = try! JSONSerialization.data(withJSONObject: jsonData)
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            if method != "GET" {
                request.httpBody = body
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    callback(nil, response, error)
                    return
                }
                guard let data = data else { return }
                do {
                    let json = try decoder.decode(T.self, from: data)
                    callback(json, response, nil)
                } catch {
                    callback(nil, response, error)
                }
            }.resume()
        }
}
