//
//  ContentView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 5/22/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var errorMessage: String?
    @State private var showSignUp = false
    
    var body: some View {
        if isLoggedIn {
            if UserDefaults.standard.object(forKey: "dream") is String {
                MainView()
            } else {
                SettingDreamView()
            }
        } else {
            VStack {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                Button(action: {
                    username = "martin1216@naver.com"
                    password = "saeha123"
                    login()
                }) {
                    Text("Admin Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                Button(action: {
                    showSignUp.toggle()
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .padding()
                }
                .sheet(isPresented: $showSignUp) {
                    SignUpView()
                }
                .padding()
            }
            .padding()
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            // 로그인 성공
            isLoggedIn = true
        }
    }
}

#Preview {
    LoginView()
}
