//
//  HistoryDetailView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 6/4/24.
//

import SwiftUI

struct HistoryDetailView: View {
    let historyItem: News

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(formatDate(historyItem.date))
                .font(.headline)
            
            Text(historyItem.title)
                .font(.title)
            
            Text(historyItem.content)
                .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("상세 보기")
    }
}

// 날짜 형식을 지정하는 함수
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}
