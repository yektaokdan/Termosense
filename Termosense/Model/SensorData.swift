import Foundation

struct SensorData {
    var temperature: Double
    var humidity: Double
    var brightness: Int
    var flame: Int
    var motion: Int
    var date: String

    init(dictionary: [String: Any]) {
        self.temperature = round((dictionary["temperature"] as? Double ?? 0.0) * 100) / 100.0
        self.humidity = round((dictionary["humidity"] as? Double ?? 0.0) * 100) / 100.0
        self.brightness = dictionary["brightness"] as? Int ?? 0
        self.flame = dictionary["flame"] as? Int ?? 0
        self.motion = dictionary["motion"] as? Int ?? 0
        self.date = (dictionary["date"] as? String)?.prefix(10).description ?? "N/A"
    }
}
