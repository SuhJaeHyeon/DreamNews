//
//  SettingView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 5/23/24.
//
import SwiftUI
import WebKit

import FirebaseAuth
import UserNotifications

struct SettingView: View {
    @AppStorage("isNotificationEnabled") private var isNotificationEnabled: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isSwitchOn = false
    @State private var showWebView = false
    var body: some View {
            NavigationView {
                List {
                    Section(header: Text("설정 1")) {
                        Toggle(isOn: $isSwitchOn) {
                            Text("push 알람 오도록 설정")
                        }
                        .onChange(of: isNotificationEnabled, { oldValue, newValue in
                            UserDefaults.standard.set(newValue, forKey: "isNotificationEnabled")
                            if newValue {
                                scheduleIntervalNotifications()
                            } else {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            }
                        })
                        
                        Button(action: {
                            self.showWebView = true
                        }) {
                            Text("바텐더리그 열기")
                        }
                        .sheet(isPresented: $showWebView) {
                            WebView(url: URL(string: "https://www.example.com")!)
                        }
                    }
                    Section(header: Text("설정 2")) {
                        Button(action: {
                            self.showWebView = true
                        }) {
                            Text("웹뷰 열기")
                        }
                        .sheet(isPresented: $showWebView) {
                            WebView(url: URL(string: "https://martin1216.shop")!)
                        }
                    }
                    Section {
                        HStack {
                            Text("버전")
                            Spacer()
                            Text(appVersion)
                                .foregroundColor(.gray)
                        }
                        Button(action: {
                            logout()
                            print("로그아웃 버튼 클릭됨")
                        }) {
                            Text("로그아웃")
                                .foregroundColor(.red)
                        }
                    }
                }
                .navigationBarTitle("설정", displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                })
            }
            .onAppear {
                requestNotificationPermission()
                if isNotificationEnabled {
                    scheduleIntervalNotifications()
                }
            }
        }
    
    
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    func scheduleHourlyNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        for hour in 0..<24 {
            let content = UNMutableNotificationContent()
            content.title = "Hourly Reminder"
            content.body = "This is your hourly notification."
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
    }
    
    func scheduleIntervalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "주노의 꿈"
        content.body = "꿈이 도착했습니다"
        content.sound = .default
 
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    var appVersion: String {
           if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
               return version
           } else {
               return "1.0"
           }
       }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // No update needed
    }
}


#Preview {
    SettingView()
}
