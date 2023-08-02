//
//  NotificationToggle.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct NotificationToggle: View {
    
    @ObservedObject var dataManager: DataManager
    let notificationManager: NotificationManager
    @Binding var notification: Bool
    var task: TaskEntity
        
    var body: some View {
        Toggle(isOn: $notification.animation()) {
            Text(task.dateLabel ?? "" == "" ? "EditViewNotification-string".localized : task.dateLabel!)
        }
        .tint(.tabBarColor)
        .onChange(of: notification) { _ in
            UIApplication.shared.endEditing(true)
            if task.notification {
                Task {
                    await notificationManager.removeRequest(task, dataManager)
                }
            }
        }
    }
}

struct NotificationToggle_Previews: PreviewProvider {
    static var previews: some View {
        let notificationManager = NotificationManager()
        let dataManager = DataManager(notificationManager: notificationManager)
        NotificationToggle(
            dataManager: dataManager,
            notificationManager: notificationManager,
            notification: .constant(true),
            task: dataManager.allTasks[0]
        )
    }
}
