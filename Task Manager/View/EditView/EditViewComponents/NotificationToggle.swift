//
//  NotificationToggle.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct NotificationToggle: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    @Binding var notification: Bool
    var task: TaskEntity
        
    var body: some View {
        Toggle(isOn: $notification.animation()) {
            Text(task.dateLabel ?? "" == "" ? "EditViewNotification-string".localized : task.dateLabel!)
//            Text("Date")
        }
        .tint(.tabBarColor)
        .onChange(of: notification) { _ in
            UIApplication.shared.endEditing(true)
            if task.notification {
                Task {
                    await NotificationManager.instance.removeRequest(task, vm)
                }
            }
        }
    }
}

struct NotificationToggle_Previews: PreviewProvider {
    static var previews: some View {
        NotificationToggle(
            notification: .constant(true),
            task: TaskManagerViewModel().allTasks[0]
        )
        .environmentObject(TaskManagerViewModel())
    }
}
