//
//  MakingStoryView.swift
//  DreamMegazin
//
//  Created by martin on 6/28/24.
//

import SwiftUI

struct MakingStoryView: View {
    @Binding var isPresented: Bool
    @State private var progress: CGFloat = 0.0
    @State private var prograssText: String = ""
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20.0)
                        .opacity(0.3)
                        .foregroundColor(Color.blue)
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.blue)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.easeInOut(duration: 2.0), value: progress)
                }
                .frame(width: 150.0, height: 150.0)
                .padding(40.0)
                Text("\(prograssText)")
                    .foregroundColor(.blue)
                    .padding()
                    .font(.ChosunFont28)
            }
            .onAppear {
                performTask_1()
            }
        }
        .navigationBarHidden(true)
    }

    private func performTask_1() {
        // whole Story
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        // StoryManager.shared.makeWholeStory(16) { story in
            progress = 1/3
            performTask_2()
        }
    }
    private func performTask_2() {
        // today Story
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        //StoryManager.shared.makeTodayStory(){ success in
            progress = 2/3
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                progress = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    isPresented = false
                }
            }
        }
    }
}
