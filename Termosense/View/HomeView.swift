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
    @State private var selectedDeviceName = "" {
        didSet {
            print("Selected Device Name: \(selectedDeviceName)")
        }
    }
    @StateObject private var sensorDataViewModel = SensorDataViewModel()
    @State private var isDeleteConfirmationPresented = false
    @State private var deviceToDelete: Device?

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("backBlue"), Color("gradient")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Image("yesilLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    if userDevicesViewModel.noDevices {
                        VStack(spacing: 20) {
                            Image("add")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .padding(20)
                            Text("Please add a device")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.white)
                        }
                    } else {
                        List {
                            ForEach(userDevicesViewModel.devices) { device in
                                DeviceRow(device: device) {
                                    selectedDeviceMac = device.mac
                                    selectedDeviceName = device.name
                                    isSplashViewPresented.toggle()
                                } onDelete: {
                                    deviceToDelete = device
                                    isDeleteConfirmationPresented.toggle()
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(PlainListStyle())
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
                SplashView(sensorDataViewModel: sensorDataViewModel, deviceName: selectedDeviceName, deviceMac: selectedDeviceMac)
            }
            .alert(isPresented: $isDeleteConfirmationPresented) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete this device?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let device = deviceToDelete, let token = UserDefaults.standard.string(forKey: "authToken") {
                            userDevicesViewModel.deleteDevice(token: token, deviceMac: device.mac)
                        }
                    },
                    secondaryButton: .cancel()
                )
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
