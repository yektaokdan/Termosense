import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var registrationSuccessful: Bool = false
    @Published var errorMessage: ErrorMessage?

    func register(firstname: String, lastname: String, email: String, password: String) {
        guard let url = URL(string: "\(Constants.baseURL)/register") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["firstname": firstname, "lastname": lastname, "email": email, "password": password]
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
                    self.registrationSuccessful = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Registration failed")
                }
            }
        }.resume()
    }
}
