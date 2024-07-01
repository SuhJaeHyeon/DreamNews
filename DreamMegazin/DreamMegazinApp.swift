//
//  DreamMegazinApp.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 5/22/24.
//

import OpenAIKit
import SwiftUI
import GoogleSignIn
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseAuth
import FirebaseCore

let organizationName: String = "Personal"


@main
struct DreamMegazinApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    init() {
        FirebaseApp.configure()
        NaverThirdPartyLoginConnection.getSharedInstance()?.isNaverAppOauthEnable = true
        NaverThirdPartyLoginConnection.getSharedInstance()?.isInAppOauthEnable = true
        NaverThirdPartyLoginConnection.getSharedInstance().setOnlyPortraitSupportInIphone(true)
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = kServiceAppUrlScheme
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = kConsumerKey
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = kConsumerSecret
        NaverThirdPartyLoginConnection.getSharedInstance().appName = kServiceAppName
    }
    var body: some Scene {
        WindowGroup {
            LoginView()
            .onOpenURL { url in
                handleIncomingURL(url: url)
            }
//            LoadingView()
//                .onOpenURL { url in
//                    handleIncomingURL(url: url)
//                }
        }
    }
    
    private func handleIncomingURL(url: URL) ->Bool{
        NSLog("[martin] scene:openURLContexts \(url)")
        if url.scheme == "futuremagazine" {
            print("URL received in SceneDelegate: \(url)")
        }
        
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        //Deployment target이 iOS 13 이상
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        if url.absoluteString.contains("thirdPartyLoginResult") {
            NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
            UserManager.shared.getNaverUserInfo()
        }
        return true
    }
}
