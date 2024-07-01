import Foundation
import FirebaseAuth
import KakaoSDKUser
import KakaoSDKAuth
import NaverThirdPartyLogin
import GoogleSignIn
import GoogleSignInSwift
import Alamofire
import SwiftUI

enum LoginType: Int, Codable {
    case none = 0
    case email = 1
    case kakao = 2
    case naver = 4
    case google = 8
    
    static let allValues = [none, email, kakao, naver, google]
}
class UserManager: ObservableObject {
    static let shared = UserManager()
    @Published var meUser: User?
    @AppStorage("loginType") var loginType: Int = LoginType.none.rawValue
    
    private init() {}
    
    func fetchUserProfile() {
        UserApi.shared.me { [weak self] user, error in
            if let error = error {
                print("사용자 정보 가져오기 실패: \(error)")
            } else {
                print("사용자 정보 가져오기 성공")
                self?.meUser?.name = user?.kakaoAccount?.profile?.nickname ?? ""
                if let profileImageUrl = user?.kakaoAccount?.profile?.profileImageUrl {
                    self?.meUser?.profileImage = profileImageUrl
                } else {
                    self?.meUser?.profileImage = nil
                }
            }
        }
    }
    
    func loginWithKakao(completion: @escaping (Bool) -> Void) {
       if UserApi.isKakaoTalkLoginAvailable() {
           UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
               if let error = error {
                   print("카카오톡으로 로그인 실패: \(error)")
                   completion(false)
               } else {
                   //do something
                   _ = oauthToken    
                   print("카카오톡으로 로그인 성공")
                   self?.fetchUserProfile()
                   completion(true)
               }
           }
       } else {
           UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
               if let error = error {
                   print("카카오 계정으로 로그인 실패: \(error)")
                   completion(false)
               } else {
                   print("카카오 계정으로 로그인 성공")
                   self?.fetchUserProfile()
                   completion(true)
               }
           }
       }
   }
    
    func getNaverUserInfo() {
        guard let tokenType = NaverThirdPartyLoginConnection.getSharedInstance().tokenType else { return }
        print("getNaverUserInfo \(NaverThirdPartyLoginConnection.getSharedInstance().accessToken)")
        guard let accessToken = NaverThirdPartyLoginConnection.getSharedInstance().accessToken else { return }
        let url = "https://openapi.naver.com/v1/nid/me"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "Bearer \(accessToken)"]
        ).responseJSON { [weak self] response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let gender = object["gender"] as? String else { return }
            guard let birthYear = object["birthyear"] as? String else { return }
            guard let profileimage = object["profile_image"] as? String else { return }
            // guard let email = object["email"] as? String else { return }
            self?.meUser = User(
                name: name,
                gender: gender,
                birthYear: birthYear,
                profileImage: URL(string: profileimage)
            )
            let naverEmail = "Naver_\(name)"
            let naverPassword = "Naver_\(name)"
            Auth.auth().createUser(withEmail: naverEmail, password: naverPassword) { authResult, error in
                
                self?.login(4, userName: naverEmail, userPW: naverPassword) { result in
                    if let errorstr = result {
                        // errorMessage = errorstr
                     }
                }
            }
            // 사용자 정보 업데이트 후 알림
            //NotificationCenter.default.post(name: Notification.Name("naverLoginSuccess"), object: nil)
        }
    }
    
    func login(_ type: Int, userName: String, userPW: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: userName, password: userPW) { authResult, error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            self.loginType |= type
            print("martin ==1== \(self.loginType)")
            completion(nil)
        }
    }

}
