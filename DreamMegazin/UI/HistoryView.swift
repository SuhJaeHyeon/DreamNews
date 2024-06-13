//
//  HistoryView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 6/4/24.
//

import SwiftUI

struct HistoryView: View {
    @State private var historyItems: [News] = []
    
    var body: some View {
        NavigationView {
            List(historyItems) { item in
                NavigationLink(destination: HistoryDetailView(historyItem: item)) {
                    HistoryCellView(historyItem: item)
                }
            }
            .navigationBarTitle("히스토리", displayMode: .inline)
            .onAppear(perform: loadHistoryItems)
        }
    }
    
    
    // JSON 파일을 읽어오는 함수
    func loadHistoryItems() {
        let fileManager = FileManager.default
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601

        let months = ["01", "02"]
        var loadedItems: [News] = []

        for month in months {
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("news_\(month).json")
                if fileManager.fileExists(atPath: fileURL.path) {
                    do {
                        let data = try Data(contentsOf: fileURL)
                        let newsItems = try jsonDecoder.decode([News].self, from: data)
                        loadedItems.append(contentsOf: newsItems)
                    } catch {
                        print("Failed to load or decode JSON for month \(month): \(error)")
                    }
                }
            }
        }
        self.historyItems = loadedItems.sorted(by: { $0.date > $1.date })
    }
}

struct HistoryCellView: View {
    let historyItem: News
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(historyItem.title)
                .font(.headline)
            
            Text(formatDate(historyItem.date))
                .font(.subheadline)
            
            Text(historyItem.content)
                .lineLimit(2)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(height: 100)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    HistoryView()
}
