import SwiftUI

struct HomeView: View {
    @StateObject private var userDevicesViewModel = UserDevicesViewModel()
    @State private var isSplashViewPresented = false
    @State private var isAddDeviceViewPresented = false
    @State private var selectedDeviceMac = "" {
        didSet {
            print("Selected Device MAC: \(selectedDeviceMac)")
        }
    }
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
        .onChange(of: selectedDeviceMac) { newValue in
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                sensorDataViewModel.fetchSensorData(token: token, deviceMac: newValue)
            }
        }
    }
}
