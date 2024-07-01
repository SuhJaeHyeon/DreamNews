//
//  SettingDreamView.swift
//  DreamMegazin
//
//  Created by martin on 6/12/24.
//

import SwiftUI

struct SettingDreamView3: View {
    @Binding var isPresented: Bool
    @State private var dream: String = ""
    @State private var isNextActive: Bool = false
    
    var body: some View {
        if isNextActive {
            MakingStoryView(isPresented: $isPresented)
        } else {
            VStack(alignment: .leading, spacing: 20) {
                VStack {
                    Text("당신의 꿈에 대해 자세히 이야기 해주세요")
                        .font(.headline)
                    TextEditor(text: $dream)
                        .frame(height: 200)  // 원하는 높이로 설정
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)  // 얇은 테두리 설정
                        )
                        .cornerRadius(10)
                }
                .padding(.top, 100)
                Spacer()
                Button(action: {
                    UserDefaults.standard.set(dream, forKey: "dreamDetail")
                    isNextActive = true
                }) {
                    Text("다음")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .navigationBarHidden(true)
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    // 키보드를 숨기는 함수
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SettingDreamView3_Previews: PreviewProvider {
    static var previews: some View {
        SettingDreamView3(isPresented: .constant(false))
    }
}
