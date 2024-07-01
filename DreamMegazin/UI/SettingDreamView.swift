//
//  SettingDreamView.swift
//  DreamMegazin
//
//  Created by martin on 6/12/24.
//

import SwiftUI

struct SettingDreamView: View {
    @Binding var isPresented: Bool
    @State private var dream: String = ""
    @State private var examples: [String] = ["유투버", "셰프", "디자이너", "의사", "변호사", "엔지니어", "예술가", "사업가", "건물주","심리상담사"]
    @State private var isNextActive: Bool = false
    
    var body: some View {
        if isNextActive {
            SettingDreamView2(isPresented: $isPresented)
        }else {
            ZStack{
                MAIN_BACK_COLOR.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack(alignment: .leading, spacing: 20, content: {
                    VStack(content: {
                        Text("당신의 꿈은 무엇인가요?")
                            .foregroundColor(MAIN_BACK_COLOR4)
                        TextField("꿈을 입력하세요", text: $dream)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    })
                    .padding(.top, 100)
                    
                    Text("예시로 선택할 수 있어요:")
                        .foregroundColor(MAIN_BACK_COLOR4)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(examples, id: \.self) { example in
                            ExampleButton(title: example, action: {
                                dream = example
                            })
                        }
                    }
                    Spacer()
                    Button(action: {
                        UserDefaults.standard.set(dream, forKey: "dream")
                        isNextActive = true
                    }) {
                        Text("다음")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(MAIN_BACK_COLOR3)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                })
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct ExampleButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus")
                Text(title)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(MAIN_BACK_COLOR3)
            .foregroundColor(.white)
            .cornerRadius(10)
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}
