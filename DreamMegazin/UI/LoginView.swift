//
//  ContentView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 5/22/24.
//

import SwiftUI
import FirebaseAuth
import NaverThirdPartyLogin
import KakaoSDKUser
import KakaoSDKAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var userName: String = ""
    @State private var userPW: String = ""
    @State private var errorMessage: String?
    @State private var showEmailLogin = false
    @State private var showSignUp = false
    @State private var isAlert = false
    @State private var alertMessage: String = ""
    @StateObject var appdelegate = AppDelegate()
    @ObservedObject var userManager = UserManager.shared

    var body: some View {  
        ZStack {
            MAIN_BACK_COLOR.edgesIgnoringSafeArea(.all) // 전체 배경을 노란색으로 설정
            if userManager.loginType > 0 {
                MainView()
            } else {
                VStack {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipped()
                    Text("\"꿈을 꿀 수 있다면, 꿈을 실현할 수도 있다.\"\n -월트 디즈니-")
                        .font(.Hero14)
                        .multilineTextAlignment(.center)
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .frame(width: 300, height: 2)
                        .foregroundColor(.black)
                        .padding()
                    if showEmailLogin {
                        Text("사용자 이름")
                            .font(.ChosunFont14)
                        TextField("Username", text: $userName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.ChosunFont14)
                            .frame(height: 50)
                            .padding()
                        Text("비밀번호")
                            .font(.ChosunFont14)
                        SecureField("비밀번호", text: $userPW)
                            .font(.ChosunFont14)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button(action: {
                            UserManager.shared.login(1, userName:userName, userPW: userPW){ result in
                                if ((result?.isEmpty) == nil) {
                                     errorMessage = result
                                 }
                            }
                        }) {
                            Text("로그인")
                                .foregroundColor(MAIN_BACK_COLOR3)
                                .padding()
                                .font(.ChosunFont14)
                        }
                        .padding()
                        Button(action: {
                            showEmailLogin = false
                        }) {
                            Text("소셜 로그인")
                                .foregroundColor(MAIN_BACK_COLOR3)
                                .padding()
                                .font(.ChosunFont14)
                        }
                        .padding()
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .frame(height: 50)
                                .padding()
                        }
                    }else {
                        HStack{
                            Spacer()
                            if UserApi.isKakaoTalkLoginAvailable() {
                                Button(action: {
                                    kakaoAuthSignIn()
                                }) {
                                    Image("kakaoLogin")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                                .cornerRadius(10)
                                Spacer()
                            }
                            Button (action:{
                                if NaverThirdPartyLoginConnection
                                    .getSharedInstance()
                                    .isPossibleToOpenNaverApp() // Naver App이 깔려있는지 확인하는 함수
                                {
                                    appdelegate.handleNaverLogin()
                                } else { // 네이버 앱 안깔려져 있을때
                                    // Appstore에서 네이버앱 열기
                                    NaverThirdPartyLoginConnection.getSharedInstance().openAppStoreForNaverApp()
                                }
                            }){
                                Image("naverLogin")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipped()
                            }
                            Spacer()
                            Button (action:{
                                googleLogin()
                            }){
                                Image("googleLogin")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipped()
                            }
                            Spacer()
                        }
                        Button(action: {
                            showEmailLogin = true
                            //login()
                        }) {
                            Text("이메일 로그인")
                                .foregroundColor(MAIN_BACK_COLOR3)
                                .padding()
                                .font(.ChosunFont14)
                        }
                        .padding()
                    }
                    
#if DEBUG
//                    Button(action: {
//                        showSignUp.toggle()
//                    }) {
//                        Text("회원 가입")
//                            .foregroundColor(MAIN_BACK_COLOR3)
//                            .padding()
//                            .font(.ChosunFont14)
//                    }
//                    .sheet(isPresented: $showSignUp) {
//                        SignUpView()
//                    }
//                    .padding()
//                    Button(action: {
//                        username = "martin1216@naver.com"
//                        password = "saeha123"
//                        login()
//                    }) {
//                        Text("Admin Login")
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
//                    .padding()
#endif
                }
                .padding()
            }
        }
//        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("naverLoginSuccess"))) { _ in
//            self.isLoggedIn = true
//        }
    }
}
extension LoginView {
    func checkState(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                print("Not sign in")
            } else {
                guard let user = user else { return }
                guard let profile = user.profile else { return }
                print("Not sign in")
//                UserManager.shared.loa
//                self.loadUserData(profile)
            }
        }
    }
    func googleLogin() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                self.alertMessage = "구글 로그인 실패: \(error.localizedDescription)"
                self.isAlert = true
                return
            }
            guard let result = signInResult, let profile = result.user.profile else { return }
            let googleEmail = "Google_\(profile.email)"
            let googlePassword = "google_pw_\(profile.email)"
            Auth.auth().createUser(withEmail: googleEmail, password: googlePassword) { authResult, error in
                userManager.login(LoginType.google.rawValue, userName:googleEmail, userPW: googlePassword) { retString in
                    if let error = retString {
                        errorMessage = error
                    }
                }
            }
            UserManager.shared.meUser = User(name: profile.name, email: profile.email, profileImage: profile.imageURL(withDimension: 180))
        }
    }
    // MARK: - KakaoAuth SignIn Function
      func kakaoAuthSignIn() {
          if AuthApi.hasToken() { // 발급된 토큰이 있는지
              UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
                  if let error = error { // 에러가 발생했으면 토큰이 유효하지 않다.
                      self.openKakaoService()
                  } else { // 유효한 토큰
                      self.loadingInfoDidKakaoAuth()
                  }
              }
          } else { // 만료된 토큰
              self.openKakaoService()
          }
      }
      
      func openKakaoService() {
          if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
              UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
                  if let error = error { // 로그인 실패 -> 종료
                      print("Kakao Sign In Error: ", error.localizedDescription)
                      return
                  }
                  
                  _ = oauthToken // 로그인 성공
                  self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
              }
          } else { // 카카오톡 앱 이용 불가능한 사람
              UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
                  if let error = error { // 로그인 실패 -> 종료
                      print("Kakao Sign In Error: ", error.localizedDescription)
                      return
                  }
                  _ = oauthToken // 로그인 성공
                  self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
              }
          }
      }
      
      func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
          UserApi.shared.me { kakaoUser, error in
              if let error = error {
                  print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                  return
              }
              guard let email = kakaoUser?.kakaoAccount?.email,
                    let password = kakaoUser?.id,
                    let nickName = kakaoUser?.kakaoAccount?.profile?.nickname else {
                  return
              }
              let kakaoEmail = "kakao_\(email)"
              let kakaoPassword = "\(password)"
              Auth.auth().createUser(withEmail: kakaoEmail, password: kakaoPassword) { authResult, error in
                   if let error = error {
                      errorMessage = error.localizedDescription
                       userName = kakaoEmail
                       userPW = kakaoPassword
                       UserManager.shared.login(2, userName: userName, userPW: userPW) { result in
                           if let errorstr = result {
                               // errorMessage = errorstr
                            }
                       }
                   } else {
                       userName = kakaoEmail
                       userPW = kakaoPassword
                       UserManager.shared.login(2, userName: userName, userPW: userPW) { result in
                           if let errorstr = result {
                               // errorMessage = errorstr
                            }
                       }
                   }
              }
          }
    }
}

#Preview {
    LoginView()
}
