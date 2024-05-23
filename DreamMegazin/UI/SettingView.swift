//
//  SettingView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 5/23/24.
//

import SwiftUI
import UserNotifications

struct SettingView: View {
    @AppStorage("isNotificationEnabled") private var isNotificationEnabled: Bool = false
     
    var body: some View {
        VStack {
            Toggle(isOn: $isNotificationEnabled) {
                Text("Enable 1-Minute Interval Notifications")
            }
            .padding()
            .onChange(of: isNotificationEnabled, { oldValue, newValue in
                UserDefaults.standard.set(newValue, forKey: "isNotificationEnabled")
                if newValue {
                    schedule5MinuteIntervalNotifications()
                } else {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
            })
        }
        .navigationTitle("Settings")
        .onAppear {
            requestNotificationPermission()
            if isNotificationEnabled {
                schedule5MinuteIntervalNotifications()
            }
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
    
    func schedule5MinuteIntervalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        for hour in 0..<24 {
            for minute in stride(from: 0, to: 60, by: 5) {
                let content = UNMutableNotificationContent()
                content.title = "5-Minute Reminder"
                content.body = "This is your 5-minute interval notification."
                content.sound = .default
                
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            }
        }
    }
    func schedule1MinuteIntervalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "주노의 꿈"
        content.body = "꿈이 도착했습니다"
        content.sound = .default
 
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}


#Preview {
    SettingView()
}
