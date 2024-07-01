//
//  ChatGPTView.swift
//  DreamMegazin
//
//  Created by martin on 6/12/24.
//

import SwiftUI
import OpenAIKit


struct ChatGPTView: View {
    @State private var responseText: String = ""
    @State private var isLoading: Bool = false
    @State private var isButtonVisible: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            Button(action: {
                startLoading()
                StoryManager.shared.makeWholeStory(16) { response in
                    print("\(response)")
                }
            }){
                Text("16 Story")
            }
            .padding()
            
            Button(action: {
                startLoading()
                StoryManager.shared.makeWholeStory(32) { response in
                    print("\(response)")
                }
            }){
                Text("32 Story")
            }
            .padding()
            
            Button(action: {
                startLoading()
                StoryManager.shared.makeWholeStory(64) { response in
                    print("\(response)")
                }
            }){
                Text("64 Story")
            }
            .padding()
            
            Button(action: {
                Task {
                    let result = await StoryManager.shared.generateImage(prompt: "해가 그러져있는 이미지를 보여줘")
                    self.image = result
                }
            }){
                Text("make Image")
            }
            .padding()
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Text(responseText)
                    .padding()
            }
            
            if isButtonVisible {
                Button(action: {
                   // sendQuestion()
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            configureObservers()
        }
    }
    
//    func sendQuestion() {
//        startLoading()
//        let previousMessages: [AIMessage] = []
//        openAI!.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: previousMessages, model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1) { result in
//            DispatchQueue.main.async {
//                stopLoading()
//                switch result {
//                case .success(let aiResult):
//                    if let text = aiResult.choices.first?.message?.content {
//                        self.responseText = text
//                    }
//                case .failure(let error):
//                    self.responseText = "Error: \(error.localizedDescription)"
//                }
//            }
//        }
//        
//        // 일반 Completion 요청
////        openAI!.sendCompletion(prompt: prompt, model: .gptV3_5(.davinciText003), maxTokens: 2048) { result in
////            // Completion 요청의 결과 처리 (필요 시)
////        }
//    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
            withAnimation {
                self.isButtonVisible = true
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation {
                self.isButtonVisible = false
            }
        }
    }
    
    func startLoading() {
        isLoading = true
    }
    
    func stopLoading() {
        isLoading = false
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView()
    }
}
