//
//  TaskRow.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct TaskRow: View {
    
    let notificationManager = NotificationManager()
    var task: TaskEntity
    @ObservedObject var dataManager: DataManager
    
    var body: some View {
        HStack {
            Image(systemName: task.completion ? "checkmark.square.fill" : "square")
                .foregroundColor(task.completion ? .tabBarColor : .primary)
                .font(.system(size: 20))
                .onTapGesture {
                    withAnimation(.linear(duration: 0.1)) {
                        HapticManager.instance.impact(style: .light)
                        dataManager.updateTask(task: task)
                        Task {
                            await notificationManager.removeRequest(task, dataManager)
                            await notificationManager.removeDelivered(task, dataManager)
                            task.dateLabel = ""
                            task.notification = false
                            dataManager.toSave()
                        }
                    }
                }
            
            Text(task.title ?? "" != "" ? task.title ?? "" : "EmptyTaskTitle-string".localized)
                .opacity(task.title ?? "" == "" ? 0.4 : 1)
                .opacity(task.completion ? 0.4 : 1)
                .font(.title3)
                .lineLimit(1)
                .padding(.leading, 5)
                .foregroundColor(.primary)
            
            if let taskNotes = task.notes {
                if taskNotes.contains(where: {$0.isLetter}) {
                    Image(systemName: "doc")
                        .foregroundColor(.secondary)
                        .font(.system(size: 15))
                }
            }
            
            if task.notification {
                Image(systemName: "bell.badge")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15))
            }
        }
        .padding(.vertical, 5)
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(
            task: DataManager(notificationManager: NotificationManager()).allTasks[0],
            dataManager: DataManager(notificationManager: NotificationManager()))
    }
}
