import SwiftUI

struct SplashView: View {
    @ObservedObject var sensorDataViewModel: SensorDataViewModel
    var deviceName: String
    var deviceMac: String
    
    @State private var isAlertPresented = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack(alignment: .center, spacing: 10) {
                    Text("Selected Device")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(deviceName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("MAC Address: \(deviceMac)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                .shadow(radius: 10)
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        SensorDataCard(icon: "thermometer", label: "Temperature", value: "\(sensorDataViewModel.sensorData.first?.temperature ?? 0) °C")
                        SensorDataCard(icon: "drop.fill", label: "Humidity", value: "\(sensorDataViewModel.sensorData.first?.humidity ?? 0) %")
                    }
                    HStack(spacing: 20) {
                        SensorDataCard(icon: "lightbulb.fill", label: "Brightness", value: sensorDataViewModel.sensorData.first?.brightness == 1 ? "On" : "Off")
                        SensorDataCard(icon: "flame.fill", label: "Flame", value: sensorDataViewModel.sensorData.first?.flame == 1 ? "Detected" : "Not Detected")
                    }
                    HStack(spacing: 20) {
                        SensorDataCard(icon: "figure.walk", label: "Motion", value: sensorDataViewModel.sensorData.first?.motion == 1 ? "Detected" : "Not Detected")
                        SensorDataCard(icon: "calendar", label: "Date", value: sensorDataViewModel.sensorData.first?.date ?? "N/A")
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                .shadow(radius: 10)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                sensorDataViewModel.fetchSensorData(token: token, deviceMac: deviceMac)
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text("Error"),
                message: Text(sensorDataViewModel.errorMessage?.message ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: sensorDataViewModel.errorMessage) { _ in
            if sensorDataViewModel.errorMessage != nil {
                isAlertPresented = true
            }
        }
    }
}

struct SensorDataCard: View {
    var icon: String
    var label: String
    var value: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("backGreen"))
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 5)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
        .frame(width: UIScreen.main.bounds.width / 2.3, height: 100)
    }
}
