//
//  ContentView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 5/22/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        if isLoggedIn {
            MainView()
        } else {
            VStack {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    // 실제 로그인 로직을 여기에 추가합니다.
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    isLoggedIn = true
//                    if !username.isEmpty && !password.isEmpty {
//                        isLoggedIn = true
//                    }
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
