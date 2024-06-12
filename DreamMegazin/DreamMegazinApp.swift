//
//  DreamMegazinApp.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 5/22/24.
//

import OpenAIKit
import SwiftUI
import FirebaseCore
let apiToken: String = ""
let organizationName: String = "Personal"

/// Initialize OpenAIKit with your API Token wherever convenient in your project. Organization name is optional.
var openAI: OpenAIKit?

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let filePath = Bundle.main.path(forResource: "api.openai.com", ofType: "cer") {
            openAI = OpenAIKit(apiToken: apiToken, organization: nil, sslCerificatePath: filePath)
        }
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct DreamMegazinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
