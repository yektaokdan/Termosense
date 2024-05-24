//
//  SensorData.swift
//  Termosense
//
//  Created by trc vpn on 24.05.2024.
//

import Foundation
struct SensorData: Identifiable {
    var id: Int
    var date: String
    var temperature: Double
    var humidity: Int
    var brightness: Int
    var flame: Int
    var motion: Int
    var mac: String

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
              let date = dictionary["date"] as? String,
              let temperature = dictionary["temperature"] as? Double,
              let humidity = dictionary["humidity"] as? Int,
              let brightness = dictionary["brightness"] as? Int,
              let flame = dictionary["flame"] as? Int,
              let motion = dictionary["motion"] as? Int,
              let mac = dictionary["mac"] as? String else {
            return nil
        }
        self.id = id
        self.date = date
        self.temperature = temperature
        self.humidity = humidity
        self.brightness = brightness
        self.flame = flame
        self.motion = motion
        self.mac = mac
    }
}
