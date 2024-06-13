//
//  TodoViewModel.swift
//  DreamMegazin
//
//  Created by martin on 6/13/24.
//

import Foundation
import EventKit

class TodoViewModel: ObservableObject {
    @Published var todoItems: [TodoItem] = []
    private var eventStore = EKEventStore()
    
    init() {
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
                self.todoItems += events.map { event in
                    TodoItem(id: UUID(), title: event.title, isCompleted: false)
                }
            }
        }
    }

    func addTodoItem(title: String) {
        let newItem = TodoItem(id: UUID(), title: title, isCompleted: false)
        todoItems.append(newItem)
    }
    
    func toggleCompletion(for item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].isCompleted.toggle()
        }
    }
    
    func removeTodoItem(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }
}
