//
//  TaskManagerViewModel.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import Foundation
import SwiftUI
import CoreData
import LocalAuthentication

// Some changes

class TaskManagerViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    
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
    
    @Published var allTasks: [TaskEntity] = []
    @Published var showSearch = false
    @Published var searchable = ""
    
    @Published var titleKeyboardFocus: Bool = false
    @Published var searchKeyboardFocus: Bool = false
    @Published var titleFocus: Bool = false
    @Published var textEditorFocus: Bool = false
    
    init() {
        container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING COREDATA \(error)")
            } else {
                self.fetchTasks()
                print("Succesfully loaded core data")
            }
        }
    }
    
    func fetchTasks() {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        do {
           allTasks = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR FETCHING \(error)")
        }
    }
    
    func addTask(title: String, note: String) {
        let newTask = TaskEntity(context: container.viewContext)
        newTask.title = title
        newTask.notes = note
        newTask.id = UUID().uuidString
        newTask.completion = false
        newTask.notification = false
        newTask.dateLabel = ""
        newTask.inRecent = false
        toSave()
    }
    
    func toSave() {
        do {
            try container.viewContext.save()
            fetchTasks()
        } catch let error {
            print("ERROR OF SAVING \(error)")
        }
    }
    
    func toCountNotCompleted() -> Int {
        var count = 0
        for task in allTasks {
            if !task.completion {
                count += 1
            }
        }
        return count
    }
    
    func updateTask(task: TaskEntity) {
        task.completion.toggle()
        if task.inRecent && !task.completion {
            task.inRecent = false
        }
        toSave()
    }
    
    func deleteTask(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let task = allTasks.reversed()[index]
        if task.notification {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id!])
        }
        container.viewContext.delete(task)
        toSave()
    }
        
    func deleteAllTasks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            NotificationManager.instance.cancelAll(self)
            try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
            fetchTasks()
        } catch let error {
            print("Failed to delete tasks. Error: \(error)")
        }
    }
    
    func addToRecent() {
        guard !allTasks.isEmpty else { return }
        for task in allTasks {
            if task.completion {
                task.inRecent = true
            }
        }
        toSave()
    }
    
    func deleteAllRecent() {
        guard !allTasks.isEmpty else {
            print("AllTasks is empty")
            return
        }
        for task in allTasks {
            if task.inRecent {
                container.viewContext.delete(task)
                print("\(task.title!) has been deleted")
            }
        }
        toSave()
    }
    
    func getBiometryType() {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if #available(iOS 11.0, *) {
                biometryType = context.biometryType == .faceID ? "faceid" : "touchid"
            } else {
                biometryType = "touchid"
            }
        }
    }
}


