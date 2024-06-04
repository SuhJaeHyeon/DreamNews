//
//  HistoryDetailView.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 6/4/24.
//

import SwiftUI

struct HistoryDetailView: View {
    let historyItem: HistoryItem
    
    var body: some View {
        VStack {
            Text(historyItem.date)
                .font(.title)
                .padding()
            
            Text(historyItem.content)
                .padding()
            
            Spacer()
        }
        .navigationBarTitle("상세 보기", displayMode: .inline)
    }
}
