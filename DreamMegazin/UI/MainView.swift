import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            NewsView()
                .tabItem {
                    Image(systemName: "doc")
                    Text("뉴스")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("히스토리")
                }
            MyPageView()
                .tabItem {
                    Image(systemName: "person")
                    Text("마이 페이지")
                }
        }
    }
}

#Preview {
    MainView()
}
