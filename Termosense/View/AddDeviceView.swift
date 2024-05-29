import SwiftUI

struct AddDeviceView: View {
    @State private var alias: String = ""
    @State private var macAddress: String = ""
    @StateObject private var addDeviceViewModel = AddDeviceViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var onDeviceAdded: (() -> Void)?
    
    var body: some View {
        ZStack{
            Color("backBlue")
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 15) {
                Image("maviLogo")
                    .resizable()
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .scaledToFit()
                    .frame(height: 250)
                
                Text("Device Alias")
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 20)
                TextField("Enter device alias", text: $alias)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 20)

                Text("MAC Address")
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 20)
                TextField("AA:22:11:BB:44:20", text: $macAddress)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 20)
                Button(action: {
                    if let token = UserDefaults.standard.string(forKey: "authToken") {
                        addDeviceViewModel.onDeviceAdded = {
                            onDeviceAdded?()
                            presentationMode.wrappedValue.dismiss()
                        }
                        addDeviceViewModel.addDevice(token: token, deviceName: alias, deviceMac: macAddress)
                    }
                }) {
                    Text("Save")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("backGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .shadow(color: Color.white.opacity(0.25), radius: 10, x: 0, y: 0)
                }
                .padding(.bottom, 20)
            }
        }
        .alert(isPresented: $addDeviceViewModel.isDeviceAdded) {
            Alert(title: Text("Success"), message: Text("Device added successfully"), dismissButton: .default(Text("OK")) {
                onDeviceAdded?()
                presentationMode.wrappedValue.dismiss()
            })
        }
        .alert(item: $addDeviceViewModel.errorMessage) { errorMessage in
            Alert(
                title: Text("Error"),
                message: Text(errorMessage.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

