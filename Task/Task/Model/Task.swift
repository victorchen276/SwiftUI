//
//  Task.swift
//  Task
//
//  Created by Chen Yue on 14/04/22.
//

import Foundation

//Task Model

struct Task: Identifiable {
    
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
    
}
