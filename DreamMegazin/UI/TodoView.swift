//
//  TodoView.swift
//  DreamMegazin
//
//  Created by martin on 6/13/24.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject var viewModel = TodoViewModel()
    @State private var showAlert = false
    @State private var itemToDelete: TodoItem?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("할 일을 입력하세요", text: $viewModel.newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        viewModel.addNewTask()
                    }) {
                        Text("추가")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .padding()
                }
                
                List {
                    Section(header: Text("할 일 목록").font(.headline)) {
                        ForEach(viewModel.todoItems.filter { !$0.isCompleted }) { item in
                            todoItemRow(item: item)
                        }
                    }
                    
                    Section(header: Text("완료됨").font(.headline)) {
                        ForEach(viewModel.todoItems.filter { $0.isCompleted }) { item in
                            todoItemRow(item: item)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle("오늘 만들기")
        }
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func todoItemRow(item: TodoItem) -> some View {
        HStack {
            Button(action: {
                viewModel.completeTask(item)
            }) {
                HStack {
                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.blue)
                    Text(item.title)
                        .strikethrough(item.isCompleted)
                    Spacer()
                }
            }
            .buttonStyle(BorderButtonStyle())
            Button(action: {
                itemToDelete = item
                showAlert = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderButtonStyle())
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("삭제"),
                    message: Text("정말로 삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        if let item = itemToDelete {
                            viewModel.removeTodoItem(item)
                        }
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
        }
    }

}
struct BorderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(4)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.clear, lineWidth: 2)
            )
    }
}

#Preview {
    TodoView()
}
