//
//  HistoryDetailView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 6/4/24.
//

import SwiftUI
struct HistoryDetailTabView: View {
    let historyItems: [News]
    let selectedItem: News

    var body: some View {
        TabView(selection: .constant(selectedItem.id)) {
            ForEach(historyItems) { item in
                FlippableHistoryDetailView(historyItem: item)
                    .tag(item.id)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct FlippableHistoryDetailView: View {
    let historyItem: News

    var body: some View {
        ZStack {
            HistoryDetailView(historyItem: historyItem)
        }
    }
}


struct HistoryDetailView: View {
    let historyItem: News

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(formatDate(historyItem.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                Text(historyItem.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                    .font(.ChosunFont28)
                
                Image(historyItem.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                
                Text(historyItem.content)
                    .font(.ChosunFont20)
                    .lineSpacing(5)
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .background(Color(.lightGray).opacity(0.3))
        .navigationTitle("상세 보기")
    }
}

// 날짜 형식을 지정하는 함수
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}
