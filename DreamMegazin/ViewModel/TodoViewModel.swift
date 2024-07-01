//
//  TodoViewModel.swift
//  DreamMegazin
//
//  Created by martin on 6/13/24.
//

import Foundation
import Combine
import EventKit

class TodoViewModel: ObservableObject {
    @Published var todoItems: [TodoItem] = []
    @Published var newTaskTitle: String = ""
    
    private var eventStore = EKEventStore()
    private let fileURL: URL
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("todoItems.json")
        
        loadTodoItems()
        requestCalendarAccess()
    }
    
    func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                self.fetchTodayEvents()
            } else {
                print("Calendar access denied.")
            }
        }
    }
    
    func fetchTodayEvents() {
        let calendars = eventStore.calendars(for: .event)
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        
        if let endDate = endDate {
            let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
            let events = eventStore.events(matching: predicate)
            
            DispatchQueue.main.async {
                for event in events {
                    if !self.todoItems.contains(where: { $0.eventIdentifier == event.eventIdentifier }) {
                        self.todoItems.append(TodoItem(title: event.title, isCompleted: false, eventIdentifier: event.eventIdentifier))
                    }
                }
                self.saveTodoItems()
            }
        }
    }

    func addNewTask() {
        guard !newTaskTitle.isEmpty else { return }
        todoItems.append(TodoItem(id: UUID(), title: newTaskTitle, isCompleted: false))
        newTaskTitle = ""
        saveTodoItems()
    }
    
    func completeTask(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].isCompleted.toggle()
            saveTodoItems()
        }
    }
    
    func removeTodoItem(_ item: TodoItem) {
        todoItems.removeAll { $0.id == item.id }
        saveTodoItems()
    }
    
    private func saveTodoItems() {
        do {
            let data = try JSONEncoder().encode(todoItems)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save todo items: \(error)")
        }
    }
    
    private func loadTodoItems() {
        do {
            let data = try Data(contentsOf: fileURL)
            todoItems = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            print("Failed to load todo items: \(error)")
        }
    }
}
