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
import WidgetKit

class DataManager: ObservableObject {
    
    @Published var allTasks: [TaskEntity] = []
    
    let container: NSPersistentContainer
    weak var notificationManager: NotificationManager?
    
    init(notificationManager: NotificationManager) {
        container = NSPersistentContainer(name: "TaskModel")
        
        let url = URL.storeURL(for: "group.com.icloud-bubiryov.Task-Manager", databaseName: "TaskModel")
        let storeDescription = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING COREDATA \(error)")
            } else {
                self.getTasks()
                print("Succesfully loaded core data")
            }
        }
        self.notificationManager = notificationManager
    }
    
    func fetchTasks() -> [TaskEntity] {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        var tasks: [TaskEntity] = []
        do {
           tasks = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR FETCHING \(error)")
        }
        WidgetCenter.shared.reloadAllTimelines()
//        objectWillChange.send()
        return tasks
    }

    func getTasks() {
        allTasks = fetchTasks()
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
        getTasks()
    }
    
    func toSave() {
        do {
            try container.viewContext.save()
//            objectWillChange.send()
//            fetchTasks()
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
        getTasks()
//        objectWillChange.send()
    }
    
    func deleteTask(indexSet: IndexSet, recentList: Bool) {
        guard let index = indexSet.first else { return }
        let task = recentList ? allTasks.filter({ $0.inRecent }).reversed()[index] : allTasks.filter({ !$0.inRecent }).reversed()[index]
        if task.notification {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id!])
        }
        container.viewContext.delete(task)
        toSave()
        getTasks()
    }
        
    func deleteAllTasks() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
            notificationManager?.cancelAll(self)
            getTasks()
        } catch {
            
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
        getTasks()
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
        getTasks()
    }
}

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Unable to create URL for \(appGroup)")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
