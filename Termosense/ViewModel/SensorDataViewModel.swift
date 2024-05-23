//
//  SensorDataViewModel.swift
//  Termosense
//
//  Created by trc vpn on 23.05.2024.
//
import Foundation
import Combine

class SensorDataViewModel: ObservableObject {
    @Published var sensorData: [SensorData] = []
    @Published var errorMessage: ErrorMessage?

    func fetchSensorData(token: String, deviceMac: String) {
        guard let url = URL(string: "http://154.53.180.108:8080/api/sensordata") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["token": token, "deviceMac": deviceMac]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: error?.localizedDescription ?? "Unknown error")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = json["status"] as? String, status == "true",
                   let sensorDataArray = json[deviceMac] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.sensorData = sensorDataArray.compactMap { SensorData(dictionary: $0) }
                        print("Sensor Data: \(self.sensorData)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = ErrorMessage(message: "Failed to fetch sensor data")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to fetch sensor data")
                }
            }
        }.resume()
    }
}



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


