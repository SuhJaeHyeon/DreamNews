import SwiftUI

struct HistoryView: View {
    @State private var historyItems: [News] = []
    @State private var isPurchaseViewPresented = false

    init() {
        // Navigation Bar Appearance 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(MAIN_BACK_COLOR)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        ZStack{
            MAIN_BACK_COLOR.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // 첫 번째 큰 카드
                        if let firstItem = historyItems.first {
                            NavigationLink(destination: HistoryDetailTabView(historyItems: historyItems, selectedItem: firstItem)) {
                                LargeHistoryCellView(historyItem: firstItem)
                            }
                        }
                        
                        // 2열로 나열되는 카드들
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(historyItems.dropFirst()) { item in
                                NavigationLink(destination: HistoryDetailTabView(historyItems: historyItems, selectedItem: item)) {
                                    SmallHistoryCellView(historyItem: item)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("히스토리", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                  isPurchaseViewPresented.toggle()
                  }) {
                      Image(systemName: "gift.fill")
                          .foregroundColor(MAIN_BACK_COLOR2)
                  })
                .onAppear(perform: loadHistoryItems)
                .background(MAIN_BACK_COLOR)
            }
        }
        .fullScreenCover(isPresented: $isPurchaseViewPresented) {
            PurchaseView(isPresented: $isPurchaseViewPresented)
        }
    }

    // JSON 파일을 읽어오는 함수
    func loadHistoryItems() {
        let fileManager = FileManager.default
        let jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        var loadedItems: [News] = []

        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            //let fileURL = documentsDirectory.appendingPathComponent("chatgpt_session.json")
            let fileURL = documentsDirectory.appendingPathComponent("news_01.json")
            if fileManager.fileExists(atPath: fileURL.path) {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let newsItems = try jsonDecoder.decode([News].self, from: data)
                    loadedItems.append(contentsOf: newsItems)
                } catch {
                    print("Failed to load or decode JSON")
                }
            }
        }
        
        self.historyItems = loadedItems.sorted(by: { $0.date > $1.date })
    }
}

struct LargeHistoryCellView: View {
    let historyItem: News

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(historyItem.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Text(historyItem.title)
                //.font(.headline)
                .font(.ChosunFont28)
                .fontWeight(.bold)
                .foregroundColor(.black) // 제목을 검은색으로 설정
                .lineLimit(1) // 한 줄로 제한
                .truncationMode(.tail) // 길어지면 ...으로 대체
            
            Text(formatDate(historyItem.date))
                .font(.ChosunFont14)
                .foregroundColor(.gray)
            
            Text(historyItem.content)
                .lineLimit(3)
                .font(.ChosunFont14)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct SmallHistoryCellView: View {
    let historyItem: News

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(historyItem.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 100)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Text(historyItem.title)
                //.font(.headline)
                .font(.ChosunFont20)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black) // 제목을 검은색으로 설정
                .lineLimit(1) // 한 줄로 제한
                .truncationMode(.tail) // 길어지면 ...으로 대체
            
            Text(formatDate(historyItem.date))
                //.font(.subheadline)
                .font(.ChosunFont14)
                .foregroundColor(.gray)
            
            Text(historyItem.content)
                .lineLimit(2)
                //.font(.body)
                .font(.ChosunFont14)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


#Preview {
    HistoryView()
}
