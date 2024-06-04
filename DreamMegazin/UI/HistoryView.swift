//
//  HistoryView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 6/4/24.
//

import SwiftUI

struct HistoryItem: Identifiable {
    let id = UUID()
    let date: String
    let content: String
}

struct HistoryView: View {
    @State private var historyItems = [
        HistoryItem(date: "2024-06-01", content: "첫 번째 히스토리 내용입니다."),
        HistoryItem(date: "2024-06-02", content: "두 번째 히스토리 내용입니다."),
        HistoryItem(date: "2024-06-03", content: "세 번째 히스토리 내용입니다.")
    ]
    
    var body: some View {
        NavigationView {
            List(historyItems) { item in
                NavigationLink(destination: HistoryDetailView(historyItem: item)) {
                    HistoryCellView(historyItem: item)
                }
            }
            .navigationBarTitle("히스토리", displayMode: .inline)
        }
    }
}

struct HistoryCellView: View {
    let historyItem: HistoryItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(historyItem.date)
                .font(.headline)
            
            Text(historyItem.content)
                .lineLimit(2)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(height: 200)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    HistoryView()
}
