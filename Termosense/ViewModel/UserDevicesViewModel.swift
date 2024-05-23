import Foundation
import Combine

class UserDevicesViewModel: ObservableObject {
    @Published var userDevices: [Device] = []
    @Published var errorMessage: ErrorMessage?

    func fetchUserDevices(token: String) {
        guard let url = URL(string: "http://154.53.180.108:8080/api/userdevices") else { return }
        
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
                   let devicesDict = json["devices"] as? [String: String] {
                    DispatchQueue.main.async {
                        self.userDevices = devicesDict.map { Device(name: $0.key, mac: $0.value) }
                        print("User Devices: \(self.userDevices)")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to fetch user devices")
                }
            }
        }.resume()
    }
}

struct Device: Identifiable {
    let id = UUID()
    let name: String
    let mac: String
}


