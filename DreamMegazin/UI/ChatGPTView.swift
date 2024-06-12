//
//  ChatGPTView.swift
//  DreamMegazin
//
//  Created by martin on 6/12/24.
//

import SwiftUI
import OpenAIKit

import SwiftUI
import OpenAIKit

struct ChatGPTView: View {
    @State private var prompt: String = ""
    @State private var responseText: String = ""
    @State private var isLoading: Bool = false
    @State private var isButtonVisible: Bool = false
    
    var body: some View {
        VStack {
            TextField("Enter your prompt", text: $prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
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
                    sendQuestion()
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
    
    func sendQuestion() {
        startLoading()
        responseText = " "
        
        let previousMessages: [AIMessage] = []
        openAI!.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: previousMessages, model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1) { result in
            DispatchQueue.main.async {
                stopLoading()
                switch result {
                case .success(let aiResult):
                    if let text = aiResult.choices.first?.message?.content {
                        self.responseText = text
                    }
                case .failure(let error):
                    self.responseText = "Error: \(error.localizedDescription)"
                }
            }
        }
        
        // 일반 Completion 요청
//        openAI!.sendCompletion(prompt: prompt, model: .gptV3_5(.davinciText003), maxTokens: 2048) { result in
//            // Completion 요청의 결과 처리 (필요 시)
//        }
    }
    
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
