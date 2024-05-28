import Foundation
import Combine

class AddDeviceViewModel: ObservableObject {
    @Published var errorMessage: ErrorMessage?
    @Published var isDeviceAdded: Bool = false
    var onDeviceAdded: (() -> Void)?

    func addDevice(token: String, deviceName: String, deviceMac: String) {
        guard let url = URL(string: "\(Constants.baseURL)/addDevice") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["token": token, "deviceName": deviceName, "deviceMac": deviceMac]
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
                    self.isDeviceAdded = true
                    self.onDeviceAdded?()
                    print("Device added successfully")
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Failed to add device")
                }
            }
        }.resume()
    }
}
