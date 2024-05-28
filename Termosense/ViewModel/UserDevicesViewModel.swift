import Foundation
import Combine

class UserDevicesViewModel: ObservableObject {
    @Published var errorMessage: ErrorMessage?
    @Published var devices: [Device] = []
    @Published var noDevices: Bool = false

    func fetchUserDevices(token: String) {
        guard let url = URL(string: "\(Constants.baseURL)/userdevices") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["token": token]
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
                   let status = json["status"] as? String {
                    if status == "true", let devicesDict = json["devices"] as? [String: String] {
                        DispatchQueue.main.async {
                            self.devices = devicesDict.map { Device(name: $0.key, mac: $0.value) }
                            self.noDevices = false
                            print("User Devices: \(self.devices)")
                        }
                    } else if status == "false" {
                        DispatchQueue.main.async {
                            self.noDevices = true
                            print("No devices found for the user")
                        }
                    }
                }
                // Response'u konsola yazdırma
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to fetch user devices")
                }
            }
        }.resume()
    }

    func deleteDevice(token: String, deviceMac: String) {
        guard let url = URL(string: "\(Constants.baseURL)/deleteDevice") else { return }
        
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
                DispatchQueue.main.async {
                    self.fetchUserDevices(token: token)
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to delete device")
                }
            }
        }.resume()
    }
}
