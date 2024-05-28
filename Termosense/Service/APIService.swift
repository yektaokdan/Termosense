
import Foundation
import Combine

class APIService: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: ErrorMessage?

    func login(email: String, password: String) {
        guard let url = URL(string: "http://154.53.180.108:8080/api/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
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
                   let token = json["token"] as? String {
                    // Token'ı UserDefaults içine kaydet
                    UserDefaults.standard.set(token, forKey: "authToken")
                    
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "Login failed")
                }
            }
        }.resume()
    }
}
