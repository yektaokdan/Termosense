import Foundation

struct SensorData {
    var temperature: Double
    var humidity: Double
    var brightness: Int
    var flame: Int
    var motion: Int
    var date: String

    init?(dictionary: [String: Any]) {
        guard let temperature = dictionary["temperature"] as? Double,
              let humidity = dictionary["humidity"] as? Double,
              let brightness = dictionary["brightness"] as? Int,
              let flame = dictionary["flame"] as? Int,
              let motion = dictionary["motion"] as? Int,
              let date = dictionary["date"] as? String else {
            return nil
        }
        self.temperature = round(temperature * 100) / 100.0
        self.humidity = round(humidity * 100) / 100.0
        self.brightness = brightness
        self.flame = flame
        self.motion = motion
        self.date = String(date.prefix(10)) // Tarih bilgisinin ilk 10 hanesi alınır
    }
}
