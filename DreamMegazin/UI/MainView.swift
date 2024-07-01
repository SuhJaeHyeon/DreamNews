import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            HistoryView()
                .tabItem {
                    Image(systemName: "doc")
                    Text("뉴스")
                }
            TodoView()
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("오늘 만들기")
                }
            ChatGPTView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("ChatGPT")
                }
            MyPageView()
                .tabItem {
                    Image(systemName: "person")
                    Text("마이 페이지")
                }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MainView()
}
