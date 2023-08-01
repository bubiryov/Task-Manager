//
//  TaskManagerViewModel.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import Foundation
import SwiftUI
import CoreData

class TaskManagerViewModel: ObservableObject {
    
    var dataManager: DataManager = DataManager()
    weak var notificationManager: NotificationManager?
    
    init() {
        notificationManager = NotificationManager.instance
    }
            
    @AppStorage("passcode") var passcode = ""
    @AppStorage("isLocked") var block = false
    @AppStorage("attempts") var attempts = 0 {
        didSet {
            if attempts > 4 && toCountAttempts {
                deleteAllTasks()
            }
        }
    }
    @AppStorage("toCountAttempts") var toCountAttempts = false
    @AppStorage("biometry") var biometryIsOn = false
    
    @Published var isUnlocked = false
    @Published var biometryType = "touchid"
    
    @Published var showSearch = false
    @Published var searchable = ""
    
    @Published var titleKeyboardFocus: Bool = false
    @Published var searchKeyboardFocus: Bool = false
    @Published var titleFocus: Bool = false
    @Published var textEditorFocus: Bool = false
        
    func fetchTasks() {
        dataManager.getTasks()
        objectWillChange.send()
    }
    
    func addTask(title: String, note: String) {
        dataManager.addTask(title: title, note: note)
    }
    
    func toSave() {
        dataManager.toSave()
        objectWillChange.send()
    }
    
    func toCountNotCompleted() -> Int {
        dataManager.toCountNotCompleted()
    }
    
    func updateTask(task: TaskEntity) {
        dataManager.updateTask(task: task)
        objectWillChange.send()
    }
    
    func deleteTask(indexSet: IndexSet, recentList: Bool) {
        dataManager.deleteTask(indexSet: indexSet, recentList: recentList)
        fetchTasks()
    }
        
    func deleteAllTasks() {
        do {
            try dataManager.deleteAllTasks()
            notificationManager?.cancelAll(self)
        } catch {
            print("Failed to delete tasks. Error: \(error)")
        }
    }
    
    func addToRecent() {
        dataManager.addToRecent()
    }
    
    func deleteAllRecent() {
        dataManager.deleteAllRecent()
        fetchTasks()
    }
    
    func getBiometryType() {
        biometryType = BiometryManager.getBiometryType()
    }
}

