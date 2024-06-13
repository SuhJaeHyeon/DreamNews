//
//  TodoView.swift
//  DreamMegazin
//
//  Created by martin on 6/13/24.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject var viewModel = TodoViewModel()
    @State private var newTodoTitle: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter new todo", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        viewModel.addTodoItem(title: newTodoTitle)
                        newTodoTitle = ""
                        hideKeyboard()
                    }) {
                        Text("Add")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
                
                List {
                    ForEach(viewModel.todoItems) { item in
                        HStack {
                            Text(item.title)
                            Spacer()
                            Button(action: {
                                viewModel.toggleCompletion(for: item)
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isCompleted ? .green : .red)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.removeTodoItem)
                }
            }
            .navigationTitle("To-Do List")
            .background(Color.white)
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}

#Preview {
    TodoView()
}
