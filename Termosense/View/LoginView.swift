import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberPassword: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            ZStack {
                Color("backBlue")
                    .edgesIgnoringSafeArea(.all) // Arka plan rengini ayarlamak

                VStack {
                    Spacer() // Yukarıda boşluk bırakmak için Spacer ekliyoruz
                    
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 40)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Email address")
                            .foregroundColor(Color.white)
                        TextField("demoattermosense.com", text: $email)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                            .foregroundColor(Color.white)

                        Text("Password")
                            .foregroundColor(Color.white)
                        SecureField("•••••••••••", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                            .foregroundColor(Color.white)

                        HStack {
                            Image(systemName: rememberPassword ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(Color("backGreen"))
                                .onTapGesture {
                                    rememberPassword.toggle()
                                }
                            Text("Remember password")
                                .foregroundColor(Color.white)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)

                    Button(action: {
                        // Button action goes here
                    }) {
                        Text("Sign In")
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

                    HStack(spacing: 0) {
                        Text("Don't have an account? ")
                            .foregroundColor(Color.white)
                        NavigationLink(destination: RegisterView()) {
                            Text("Sign up")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                    .padding(.bottom, 20)

                    Spacer()

                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.white)
                        Text("Go back")
                            .foregroundColor(Color.white)
                    }
                    .padding(.bottom, 30)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
