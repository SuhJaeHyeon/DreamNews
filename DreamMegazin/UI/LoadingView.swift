import SwiftUI
import FirebaseAuth

struct LoadingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isAnimating: Bool = false
    @State private var navigateToMainView = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20.0)
                        .opacity(0.3)
                        .foregroundColor(Color.blue)

                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.blue)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.easeInOut(duration: 2.0), value: progress)
                }
                .frame(width: 150.0, height: 150.0)
                .padding(40.0)
                Button (action: {
                    navigateToMainView = true
                }) {
                    Text("넘어가기")
                        .foregroundColor(.blue)
                        .padding()
                        .font(.ChosunFont28)
                }
                .font(.ChosunFont28)
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $navigateToMainView) {
                    EmptyView()
                }
                .hidden()
            }
            .onAppear {
                performTasks()
                do {
                    try Auth.auth().signOut()
                    UserDefaults.standard.set(0, forKey: "loginType")
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
                UserDefaults.standard.set(0, forKey: "loginType")
            }
        }
    }

    private func performTasks() {
        let taskCount = 3
        progress = 1/3
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            progress = 2/3
           // sendPrompt(prompt)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            progress = 1
            navigateToMainView = true
           // sendPrompt(prompt)
        }
    }
    
    @State private var isLoading: Bool = false
    @State private var responseText: String = ""
    @State private var prompt: String = ""
    
    func startLoading() {
        isLoading = true
    }
    
    func stopLoading() {
        isLoading = false
    }
}
