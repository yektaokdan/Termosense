import SwiftUI

struct AddDeviceView: View {
    @State private var alias: String = ""
    @State private var macAddress: String = ""
    @StateObject private var addDeviceViewModel = AddDeviceViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("backBlue")
                    .edgesIgnoringSafeArea(.all) // Arka plan rengini ayarlamak

                VStack(alignment: .leading, spacing: 15) {
                    Image("logo")
                        .resizable()
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.top, 10) // Üst kısımdan biraz boşluk ekleyelim
                        .scaledToFit()
                        .frame(height: 250) // İsteğe bağlı olarak görüntü yüksekliğini ayarlayabilirsiniz
                    
                    Text("Device Alias")
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 20) // Sağdan ve soldan padding ekliyoruz
                    TextField("Enter device alias", text: $alias)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5)
                        .foregroundColor(Color.white)
                        .autocapitalization(.none) // Otomatik büyük harfle başlamayı engellemek için
                        .disableAutocorrection(true)
                        .padding(.horizontal, 20) // Sağdan ve soldan padding ekliyoruz

                    Text("MAC Address")
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 20) // Sağdan ve soldan padding ekliyoruz
                    TextField("AA:22:11:BB:44:20", text: $macAddress)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5)
                        .foregroundColor(Color.white)
                        .autocapitalization(.none) // Otomatik büyük harfle başlamayı engellemek için
                        .disableAutocorrection(true)
                        .padding(.horizontal, 20) // Sağdan ve soldan padding ekliyoruz
                    Button(action: {
                        if let token = UserDefaults.standard.string(forKey: "authToken") {
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
                            .shadow(color: Color.white.opacity(0.25), radius: 10, x: 0, y: 0) // Butonun etrafına ışık efekti eklemek için shadow ekliyoruz
                    }
                    .padding(.bottom, 20) // Butonun en alt kısmı ekranın alt kısmına yaklaşması için padding ekliyoruz
                }
            }
            .alert(isPresented: $addDeviceViewModel.isDeviceAdded) {
                Alert(title: Text("Success"), message: Text("Device added successfully"), dismissButton: .default(Text("OK")) {
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
}

struct AddDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeviceView()
    }
}
