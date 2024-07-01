import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let randomNumber = Int.random(in: 1000...9999) // 1000에서 9999 사이의 랜덤 숫자 생성
        let userName = UserManager.shared.meUser?.name ?? "드림_\(randomNumber)"
        let email = UserManager.shared.meUser?.email ?? "hong@example.com"
        self.user = User(name: userName, email: email)
        
        UserManager.shared.$meUser
            .sink { [weak self] meUser in
                guard let self = self, let meUser = meUser else { return }
                self.user.name = meUser.name
                self.user.email = meUser.email
                // 필요하다면 profileImageData도 업데이트
                // self.user.profileImageData = meUser.profileImageData
            }
            .store(in: &cancellables)
    }

    func updateProfile(name: String, email: String, profileImage: String) {
        user.name = name
        user.email = email
        user.profileImageData = profileImage
    }
}
