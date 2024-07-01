//
//  MyPageView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 6/4/24.
//

import SwiftUI

struct MyPageView: View {
    @State private var showSettings = false
    @StateObject private var userViewModel = UserViewModel()
       
       var body: some View {
           NavigationView {
               VStack {
                   VStack {
                       if let url = userViewModel.user.profileImage {
                           if #available(iOS 15.0, *) {
                               AsyncImage(url: userViewModel.user.profileImage)
                                   .frame(width: 100, height: 100)
                                   .clipShape(Circle())
                           } else {
                               Image(systemName: "person.circle.fill")
                                   .resizable()
                                   .frame(width: 100, height: 100)
                                   .clipShape(Circle())
                           }
                       } else {
                           Image(systemName: "person.circle.fill")
                               .resizable()
                               .frame(width: 100, height: 100)
                               .clipShape(Circle())
                       }
                       Text(userViewModel.user.name)
                           .font(.title)
                           .fontWeight(.medium)
                       Text(userViewModel.user.email)
                           .font(.subheadline)
                           .foregroundColor(.gray)
                   }
                   .padding()
                   
                   List {
                       NavigationLink(destination: ProfileEditView().environmentObject(userViewModel)) {
                           HStack {
                               Image(systemName: "pencil")
                               Text("프로필 수정")
                           }
                       }
//                       NavigationLink(destination: ProfileDreamView()) {
//                           HStack {
//                               Image(systemName: "pencil")
//                               Text("꿈 수정")
//                           }
//                       }
                       NavigationLink(destination: QuestView()) {
                           HStack {
                               Image(systemName: "checkmark.circle")
                               Text("퀘스트")
                           }
                       }
                       ZStack {
                           Button(action: openKakaoChat) {
                               HStack {
                                   Image(systemName: "questionmark")
                                   Text("고객문의")
                               }
                           }
                           .padding()
                       }
                       NavigationLink(destination: NoticesView()) {
                           HStack {
                               Image(systemName: "megaphone")
                               Text("공지/안내")
                           }
                       }
                       NavigationLink(destination: SettingView()) {
                           HStack {
                               Image(systemName: "gearshape")
                               Text("설정")
                           }
                       }
                   }
                   .listStyle(PlainListStyle())
                   
               }
               .environmentObject(userViewModel)
           }
       }
    func openKakaoChat() {
       let chatURL = "https://open.kakao.com/o/gG9tNKyg"
       if let url = URL(string: chatURL), UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       } else {
           // 카카오톡 앱이 설치되어 있지 않거나 URL을 열 수 없는 경우
           print("카카오톡을 열 수 없습니다.")
       }
   }
}

struct ProfileHeaderView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        VStack { 
            if let url = userViewModel.user.profileImage {
                if #available(iOS 15.0, *) {
                    AsyncImage(url: userViewModel.user.profileImage)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            Text(userViewModel.user.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(userViewModel.user.email)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct QuestView: View {
    var body: some View {
        Text("Quest View")
    }
}

struct InviteFriendView: View {
    var body: some View {
        Text("Invite Friend View")
    }
}

struct NoticesView: View {
    var body: some View {
        Text("Notices View")
    }
}

#Preview {
    MyPageView()
}
