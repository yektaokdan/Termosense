import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("backGreen")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    Image("maviLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 33.5)
                        .padding(.bottom, 10)
                    Spacer()
                    Image("termosense")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .padding(.bottom, 20)

                    HStack {
                        Text("How does")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("backBlue"))
                        
                        Text("Termosense")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Text("help?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("backBlue"))
                    }
                    .padding(.bottom, 10)

                    Text("Dive deep into your home’s environment metrics so you can strategically manage and enhance your living space.")
                        .foregroundColor(Color("backBlue"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    Spacer()

                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                        Text("Continue")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("backBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}
