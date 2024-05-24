import SwiftUI

struct SplashView: View {
    @ObservedObject var sensorDataViewModel: SensorDataViewModel
    var deviceMac: String

    var body: some View {
        ZStack {
            Color("backBlue")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if sensorDataViewModel.isLoading {
                    Text("Fetching Sensor Data...")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.white)
                } else if let sensorData = sensorDataViewModel.sensorData.first {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Sensor Data for Device: \(deviceMac)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        SensorDataRow(icon: "thermometer", label: "Temperature", value: "\(sensorData.temperature) °C")
                        SensorDataRow(icon: "drop.fill", label: "Humidity", value: "\(sensorData.humidity) %")
                        SensorDataRow(icon: "lightbulb.fill", label: "Brightness", value: sensorData.brightness == 1 ? "On" : "Off")
                        SensorDataRow(icon: "flame.fill", label: "Flame", value: sensorData.flame == 1 ? "Detected" : "Not Detected")
                        SensorDataRow(icon: "figure.walk", label: "Motion", value: sensorData.motion == 1 ? "Detected" : "Not Detected")
                        SensorDataRow(icon: "calendar", label: "Date", value: sensorData.date)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                    .shadow(radius: 10)
                } else {
                    VStack {
                        Text("No Sensor Data Available")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.white)

                        Button(action: {
                            if let token = UserDefaults.standard.string(forKey: "authToken") {
                                sensorDataViewModel.fetchSensorData(token: token, deviceMac: deviceMac)
                            }
                        }) {
                            Text("Retry")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                sensorDataViewModel.fetchSensorData(token: token, deviceMac: deviceMac)
            }
        }
        .alert(item: $sensorDataViewModel.errorMessage) { errorMessage in
            Alert(
                title: Text("Error"),
                message: Text(errorMessage.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
