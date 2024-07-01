import SwiftUI

struct TutorialView: View {
    @State private var currentPage = 0
    let tutorialText = [
            "꿈 신문사에서는 여러분들의 꿈에 대해 써준답니다. 여러분들이 꿈을 이룰 수 있게요.",
            "꿈을 먼저 구매하세요! 매 주 월, 수, 금 아침 8시에 꿈 신문을 보내드려요.",
            "이루고 싶은 꿈을 상세하게 설정해보세요",
            "구매한 꿈 신문은 매주 월,수,금 아침 8시에 배송됩니다.",
            "오늘의 꿈 신문을 보고 오늘의 할 일을 정리하세요.\n그리고 달성하세요!\n당신은 꿈에 한발자국 다가서게 될거에요 :)"
        ]
    
    
    var body: some View {
        let pages: [TutorialPage] = [
            TutorialPage(imageName: "dreamSample", text: tutorialText[0]),
            TutorialPage(imageName: "dreamSample", text: tutorialText[1]),
            TutorialPage(imageName: "dreamSample", text: tutorialText[2]),
            TutorialPage(imageName: "dreamSample", text: tutorialText[3]),
            TutorialPage(imageName: "dreamSample", text: tutorialText[4])
        ]
        ZStack {
            MAIN_BACK_COLOR.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image(pages[currentPage].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                Text(pages[currentPage].text)
                    .padding()
                    .foregroundColor(MAIN_BACK_COLOR3)
                    .font(.ChosunFont14)
                
                Spacer()
                ZStack {
                    HStack {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage = max(currentPage - 1, 0)
                                    print(" -- \(currentPage)")
                                }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                            }
                        }
                        
                        Spacer()
                        if currentPage < pages.count - 1 {
                            Button(action: {
                                withAnimation {
                                    currentPage = min(currentPage + 1, 4)
                                    print(" ++ \(currentPage)")
                                }
                            }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                            }
                        }
                    }
                    HStack{
                        Spacer()
                        if currentPage == pages.count - 1 {
                            NavigationLink(destination: MainView()) {
                                Text("시작하기")
                                    .padding()
                                    .frame(height: 50)
                                    .background(MAIN_BACK_COLOR3)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .font(.ChosunFont20)
                            }
                            .padding()
                        }
                        Spacer()
                    }
                }
                .padding()
                HStack {
                    ForEach(0..<pages.count) { index in
                        Circle()
                            .fill(index == currentPage ? Color.gray : Color.clear)
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle().stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(4)
                    }
                }
                .padding()
            }
        }
        .background(MAIN_BACK_COLOR)
        .navigationBarHidden(true)
    }
}

struct TutorialPage {
    let imageName: String
    let text: String
}

#Preview {
    TutorialView()
}
