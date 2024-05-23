import SwiftUI

struct HomeView: View {
    @StateObject private var userDevicesViewModel = UserDevicesViewModel()
    @State private var isSplashViewPresented = false
    @State private var isAddDeviceViewPresented = false
    @State private var selectedDeviceMac = ""
    @StateObject private var sensorDataViewModel = SensorDataViewModel()

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

                    if userDevicesViewModel.noDevices {
                        Text("Please add a device")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.white)
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(userDevicesViewModel.devices) { device in
                                    DeviceRow(device: device) {
                                        selectedDeviceMac = device.mac
                                        isSplashViewPresented.toggle()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    Spacer()
                }
            }
            .navigationBarItems(trailing: Button(action: {
                isAddDeviceViewPresented.toggle()
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            })
            .sheet(isPresented: $isAddDeviceViewPresented) {
                AddDeviceView(onDeviceAdded: {
                    if let token = UserDefaults.standard.string(forKey: "authToken") {
                        userDevicesViewModel.fetchUserDevices(token: token)
                    }
                })
            }
            .sheet(isPresented: $isSplashViewPresented) {
                SplashView(sensorDataViewModel: sensorDataViewModel, deviceMac: selectedDeviceMac)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                print("Stored Token: \(token)")
                userDevicesViewModel.fetchUserDevices(token: token)
            } else {
                print("No token found")
            }
        }
        .alert(item: $userDevicesViewModel.errorMessage) { errorMessage in
            Alert(
                title: Text("Error"),
                message: Text(errorMessage.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct DeviceRow: View {
    var device: Device
    var onTap: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(device.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white)
                
                Text(device.mac)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color.white)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("backGreen").opacity(0.8))
                .shadow(color: Color("backGreen").opacity(0.4), radius: 10, x: 0, y: 5)
        )
        .onTapGesture {
            onTap()
        }
    }
}

struct SensorData1: Identifiable {
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
