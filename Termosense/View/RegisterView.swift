import SwiftUI

struct RegisterView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color("backBlue")
                .edgesIgnoringSafeArea(.all) // Arka plan rengini ayarlamak

            VStack {
                    
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("First Name")
                                .foregroundColor(Color.white)
                            TextField("Yusuf", text: $firstName)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(5)
                                .foregroundColor(Color.white)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Last Name")
                                .foregroundColor(Color.white)
                            TextField("Aktan", text: $lastName)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(5)
                                .foregroundColor(Color.white)
                        }
                    }

                    Text("Email address")
                        .foregroundColor(Color.white)
                    TextField("demoattermosense.com", text: $email)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5)
                        .foregroundColor(Color.white)

                    Text("Password")
                        .foregroundColor(Color.white)
                    SecureField("•••••••••••", text: $password)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5)
                        .foregroundColor(Color.white)

                    Text("Confirm Password")
                        .foregroundColor(Color.white)
                    SecureField("•••••••••••", text: $confirmPassword)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5)
                        .foregroundColor(Color.white)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                Button(action: {
                    // Button action goes here
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("backGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .shadow(color: Color.white.opacity(0.25), radius: 10, x: 0, y: 0) // B
                }
                .padding(.bottom, 20) // Butonun en alt kısmı ekranın alt kısmına yaklaşması için padding ekliyoruz
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
