//
//  MyPageView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 6/4/24.
//

import SwiftUI

struct MyPageView: View {
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileHeaderView()
                
                List {
                    Section(header: Text("개인 정보")) {
                        HStack {
                            Text("이름")
                            Spacer()
                            Text("홍길동")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("이메일")
                            Spacer()
                            Text("hong@example.com")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("전화번호")
                            Spacer()
                            Text("010-1234-5678")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationBarTitle("마이 페이지", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showSettings = true
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
            })
            .sheet(isPresented: $showSettings) {
                SettingView()
            }
        }
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            
            Text("홍길동")
                .font(.title)
                .fontWeight(.bold)
            
            Text("hong@example.com")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    MyPageView()
}
