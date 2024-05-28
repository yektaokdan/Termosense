import SwiftUI

struct RegisterView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var registerViewModel = RegisterViewModel()

    var body: some View {
        NavigationView{
            ZStack {
                Color("backBlue")
                    .edgesIgnoringSafeArea(.all)

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
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        Text("Password")
                            .foregroundColor(Color.white)
                        SecureField("•••••••••••", text: $password)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                            .foregroundColor(Color.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        Text("Confirm Password")
                            .foregroundColor(Color.white)
                        SecureField("•••••••••••", text: $confirmPassword)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                            .foregroundColor(Color.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    Button(action: {
                        guard password == confirmPassword else {
                            registerViewModel.errorMessage = ErrorMessage(message: "Passwords do not match")
                            return
                        }
                        registerViewModel.register(firstname: firstName, lastname: lastName, email: email, password: password)
                    }) {
                        Text("Sign Up")
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
                .alert(item: $registerViewModel.errorMessage) { errorMessage in
                    Alert(
                        title: Text("Error"),
                        message: Text(errorMessage.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onChange(of: registerViewModel.registrationSuccessful) { success in
                if success {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        }
        
}
