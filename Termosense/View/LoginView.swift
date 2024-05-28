import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberPassword: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var authViewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color("backBlue")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 40)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Email address")
                            .foregroundColor(Color.white)
                        
                        ZStack(alignment: .leading) {
                            if email.isEmpty {
                                Text("demoattermosense.com")
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .padding(.horizontal, 15)
                            }
                            TextField("", text: $email)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(5)
                                .foregroundColor(Color.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }

                        Text("Password")
                            .foregroundColor(Color.white)
                        
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("•••••••••••")
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .padding(.horizontal, 15)
                            }
                            SecureField("", text: $password)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(5)
                                .foregroundColor(Color.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }

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
                        authViewModel.login(email: email, password: password)
                    }) {
                        Text("Sign In")
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
                
                NavigationLink(
                    destination: HomeView(),
                    isActive: $authViewModel.isAuthenticated
                ) {
                    EmptyView()
                }
            }
            .alert(item: $authViewModel.errorMessage) { errorMessage in
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
