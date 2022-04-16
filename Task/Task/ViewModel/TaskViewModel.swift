//
//  TaskViewModel.swift
//  Task
//
//  Created by Chen Yue on 14/04/22.
//

import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    
    //Sample Tasks
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1650033067)),
        Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1650072667)),
        Task(taskTitle: "WooHoo", taskDescription: "Hello world", taskDate: .init(timeIntervalSince1970: 1650119467))
    ]
    //1650119467
    
    //Current Week Days
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var filteredTasks: [Task]?
    
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInitiated).async {
            let filtered = self.storedTasks
                .filter { Calendar.current.isDate($0.taskDate, inSameDayAs: self.currentDay) }
                .sorted { $1.taskDate < $0.taskDate }
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
//                    self.filteredTasks = self.storedTasks
                }
            }
        }
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calender = Calendar.current
        let week = calender.dateInterval(of: .weekOfMonth, for: today)
        guard let firstWeekDay = week?.start else { return }
        (1...7).forEach { day in
            if let weekday = calender.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
//        isDateInToday(date)
    }
    
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        return hour == currentHour
    }
    
}
