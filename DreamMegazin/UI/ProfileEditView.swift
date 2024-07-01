//
//  ProfileEditView.swift
//  DreamMegazin
//
//  Created by martin on 6/21/24.
//

import SwiftUI

struct ProfileEditView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var profileImage: UIImage?
    @State private var profileImageData: String?
    @State private var showImagePicker = false
    
    var body: some View {
        Form {
            Section(header: Text("프로필 이미지")) {
                HStack {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("이미지 선택")
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $profileImage)
                    }
                }
            }
            Section(header: Text("이름")) {
                TextField("이름", text: $name)
            }
            Section(header: Text("이메일")) {
                TextField("이메일", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            Button(action: {
                if let imageData = profileImage?.jpegData(compressionQuality: 0.8) {
                    let base64Image = imageData.base64EncodedString()
                    userViewModel.updateProfile(name: name, email: email, profileImage: base64Image)
                } else {
                    userViewModel.updateProfile(name: name, email: email, profileImage: "")
                }
            }) {
                Text("저장")
            }
        }
        .onAppear {
            name = userViewModel.user.name
            email = userViewModel.user.email
            if let data = Data(base64Encoded: userViewModel.user.profileImageData), let uiImage = UIImage(data: data) {
                profileImage = uiImage
            }
        }
        .navigationBarTitle("프로필 수정", displayMode: .inline)
    }
}

#Preview {
    ProfileEditView()
}
