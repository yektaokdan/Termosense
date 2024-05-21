import SwiftUI

struct HomeView: View {
    @State private var sensorData: SensorData = SensorData(id: 36, date: "2024-05-21T01:02:55", temperature: 26.7, humidity: 63, brightness: 1, flame: 0, motion: 1, mac: "50:02:91:ED:D0:20")

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("backBlue"), Color("gradient")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Termosense")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white)
                        .padding(.top, 40)
                        .padding(.bottom, 20)

                    VStack(spacing: 20) {
                        SensorCardView(sensorName: "Temperature", sensorValue: "\(sensorData.temperature) °C", sensorIcon: "thermometer.snowflake", cardColor: Color.red)
                        SensorCardView(sensorName: "Humidity", sensorValue: "\(sensorData.humidity) %", sensorIcon: "drop.fill", cardColor: Color.blue)
                        SensorCardView(sensorName: "Brightness", sensorValue: sensorData.brightness == 1 ? "On" : "Off", sensorIcon: "lightbulb.fill", cardColor: Color.yellow)
                        SensorCardView(sensorName: "Flame", sensorValue: sensorData.flame == 1 ? "Detected" : "Not Detected", sensorIcon: "flame.fill", cardColor: Color.orange)
                        SensorCardView(sensorName: "Motion", sensorValue: sensorData.motion == 1 ? "Detected" : "Not Detected", sensorIcon: "figure.walk.circle.fill", cardColor: Color.green)
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
        }
    }
}

struct SensorCardView: View {
    var sensorName: String
    var sensorValue: String
    var sensorIcon: String
    var cardColor: Color

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(cardColor.opacity(0.7))
                    .frame(width: 70, height: 70)
                Image(systemName: sensorIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
            .padding(.leading, 10)

            VStack(alignment: .leading) {
                Text(sensorName)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white)

                Text(sensorValue)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
            }
            .padding(.leading, 10)

            Spacer()
        }
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(gradient: Gradient(colors: [cardColor.opacity(0.4), cardColor]), startPoint: .leading, endPoint: .trailing))
                .shadow(color: cardColor.opacity(0.4), radius: 10, x: 0, y: 5)
        )
        .padding(.vertical, 10)
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
