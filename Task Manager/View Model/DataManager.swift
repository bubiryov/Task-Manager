//
//  DataManager.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 16.04.2023.
//

import Foundation
import CoreData
import UserNotifications
import SwiftUI

class DataManager: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var allTasks: [TaskEntity] = []
    
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
        
    func deleteAllTasks(_ vm: TaskManagerViewModel) {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            NotificationManager.instance.cancelAll(vm)
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


}
