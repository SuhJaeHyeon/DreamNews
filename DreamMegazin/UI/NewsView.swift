//
//  NewsView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 6/4/24.
//

import SwiftUI

struct NewsView: View {
    @State private var dreamText: String = ""
    var body: some View {
        NavigationView {
            VStack {
                Text("준호의 꿈")
                    .font(.largeTitle)
                    .padding()
                if dreamText.isEmpty {
                    Text("Loading...")
                        .font(.largeTitle)
                        .padding()
                } else {
                    ScrollView {
                       Text(dreamText)
                           .font(.body)
                           .padding()
                   }
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onAppear {
                loadDreamText()
            }
        }
    }
    
    func loadDreamText() {
        dreamText = "준비중입니다"
//        
//        if let filePath = Bundle.main.path(forResource: "dream", ofType: "txt") {
//            do {
//                let contents = try String(contentsOfFile: filePath)
//                dreamText = contents
//            } catch {
//                dreamText = "Failed to load content."
//            }
//        } else {
//            dreamText = "File not found."
//        }
//        dreamText = "준비중입니다"
    }
}

#Preview {
    NewsView()
}
