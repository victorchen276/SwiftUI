//
//  TaskViewModel.swift
//  Task
//
//  Created by Chen Yue on 14/04/22.
//

import Foundation

class TaskViewModel: ObservableObject {
    
    //Sample Tasks
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1641645497)),
        Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1641649097))
    ]
    
    //Current Week Days
    @Published var currentWeek: [Date] = []
    
    init() {
        fetchCurrentWeek()
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
    
}
