import SwiftUI

struct MainView: View {
    @State private var dreamText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{ 
                    NavigationLink(destination: SettingView()) {
                        Text("Settings")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    Button(
                        action: {
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        }){
                            NavigationLink(destination: SettingView()) {
                                Text("Logout")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    .padding()
                }
                Text("준호의 꿈")
                    .font(.largeTitle)
                    .padding()
                if dreamText.isEmpty {
                    Text("Loading...")
                        .font(.largeTitle)
                        .padding()
                } else {
                    ScrollView {
                       Text(dreamText)
                           .font(.body)
                           .padding()
                   }
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onAppear {
                loadDreamText()
            }
        }
    }
    func loadDreamText() {
        if let filePath = Bundle.main.path(forResource: "dream", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filePath)
                dreamText = contents
            } catch {
                dreamText = "Failed to load content."
            }
        } else {
            dreamText = "File not found."
        }
    }
}

#Preview {
    MainView()
}
