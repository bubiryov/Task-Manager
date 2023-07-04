//
//  NotificationManager.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 06.03.2023.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager {
    
    static let instance = NotificationManager()
        
    func makeNotification(task: TaskEntity, vm: TaskManagerViewModel, date: Date) {
                
        let content = UNMutableNotificationContent()
        content.title = task.title!
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: date)
        dateComponents.minute = Calendar.current.component(.minute, from: date)
        dateComponents.day = Calendar.current.component(.day, from: date)
        dateComponents.month = Calendar.current.component(.month, from: date)
        dateComponents.year = Calendar.current.component(.year, from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: task.id ?? "",
            content: content,
            trigger: trigger)

        UNUserNotificationCenter.current().add(request)

        task.notification = true
        task.dateLabel = date.formatted()
        vm.toSave()
        print("New request done")
    }
    
    func addNotification(task: TaskEntity, vm: TaskManagerViewModel, date: Date) async {
        if task.notification {
            Task {
                await removeRequest(task, vm)
                await MainActor.run(body: {
                    makeNotification(task: task, vm: vm, date: date)
                })
            }
        } else {
            Task {
                await MainActor.run(body: {
                    makeNotification(task: task, vm: vm, date: date)
                })
            }
        }
    }
    
    func cancelAll(_ vm: TaskManagerViewModel) {
        for task in vm.dataManager.allTasks {
            task.notification = false
            task.dateLabel = ""
            vm.toSave()
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func getDeliveredNotifications() async -> [UNNotification] {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                continuation.resume(with: .success(notifications))
            }
        }
    }
    
    func removeDelivered(_ task: TaskEntity, _ vm: TaskManagerViewModel) async {
        let deliveredNotifications = await getDeliveredNotifications()
        for notification in deliveredNotifications {
            let identifier = notification.request.identifier
            if identifier == task.id {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
                await MainActor.run {
                    UIApplication.shared.applicationIconBadgeNumber -= 1
                    task.notification = false
                    task.dateLabel = ""
                    vm.toSave()
                }
                print("Delivered notification deleted")
            }
        }
    }
    
    func getPendingNotifications() async throws -> [UNNotificationRequest] {
        return try await withCheckedThrowingContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                continuation.resume(with: .success(requests))
            }
        }
    }
    
    func removeRequest(_ task: TaskEntity, _ vm: TaskManagerViewModel) async {
        do {
            let requests = try await getPendingNotifications()
            for request in requests {
                if request.identifier == task.id {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    await MainActor.run {
                        task.dateLabel = ""
                        task.notification = false
                        vm.toSave()
                    }
                    print("Request deleted")
                } else {
                    print("Request was not found")
                }
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
}
