import Foundation
import Combine

class SensorDataViewModel: ObservableObject {
    @Published var sensorData: [SensorData] = []
    @Published var errorMessage: ErrorMessage?
    @Published var isLoading: Bool = false

    func fetchSensorData(token: String, deviceMac: String) {
        guard let url = URL(string: "http://154.53.180.108:8080/api/sensordata") else {
            DispatchQueue.main.async {
                self.errorMessage = ErrorMessage(message: "Invalid URL")
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["token": token, "deviceMac": deviceMac]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        // JSON verisini günlüğe kaydetme
        if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("HTTP Body: \(jsonString)")
        }

        DispatchQueue.main.async {
            self.isLoading = true
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: error?.localizedDescription ?? "Unknown error")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let status = json["status"] as? String, status == "true",
                       let sensorDataArray = json[deviceMac] as? [[String: Any]] {
                        DispatchQueue.main.async {
                            self.sensorData = sensorDataArray.compactMap { SensorData(dictionary: $0) }
                            print("Sensor Data: \(self.sensorData)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = ErrorMessage(message: "Failed to parse sensor data")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = ErrorMessage(message: "HTTP Error: \(httpResponse.statusCode)")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Unknown response error")
                }
            }
        }.resume()
    }
}
