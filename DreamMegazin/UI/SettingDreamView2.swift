//
//  SettingDreamView2.swift
//  DreamMegazin
//
//  Created by martin on 6/12/24.
//

import SwiftUI

struct SettingDreamView2: View {
    @State private var dream: String = ""
    @State private var examples: [String] = ["1년", "3년", "5년", "10년", "20년"]
    @State private var isNextActive: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            VStack(content: {
                Text("당신의 꿈은 언제 이루어지나요?")
                TextField("목표 기간을 입력하세요", text: $dream)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            })
            .padding(.top, 100)
            
            Text("예시로 선택할 수 있어요:")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(examples, id: \.self) { example in
                    ExampleButton(title: example, action: {
                        dream = example
                    })
                }
            }
            Spacer()
            
            NavigationLink(destination: MainView(), isActive: $isNextActive) {
                Button(action: {
                    UserDefaults.standard.set(dream, forKey: "Time")
                    isNextActive = true
                }) {
                    Text("다음")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        })
        .padding()
        .navigationTitle("설정")
    }
}

#Preview {
    SettingDreamView2()
}
