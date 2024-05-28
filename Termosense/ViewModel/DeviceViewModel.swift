import Foundation
import Combine

class DeviceViewModel: ObservableObject {
    @Published var errorMessage: ErrorMessage?
    @Published var deletionSuccess: Bool = false

    func deleteDevice(token: String, deviceMac: String) {
        print("Delete device called with token: \(token) and deviceMac: \(deviceMac)")
        
        guard let url = URL(string: "\(Constants.baseURL)/deleteDevice") else {
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

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: error.localizedDescription)
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.deletionSuccess = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = ErrorMessage(message: "Failed to delete the device")
                    }
                }
            } else {
                print("Unknown response error")
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Unknown response error")
                }
            }
        }.resume()
    }
}
