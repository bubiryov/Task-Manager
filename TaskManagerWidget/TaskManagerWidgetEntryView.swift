//
//  TaskManagerWidgetEntryView.swift
//  TaskManagerWidgetExtension
//
//  Created by Egor Bubiryov on 02.08.2023.
//

import SwiftUI
import WidgetKit

struct TaskManagerWidgetEntryView : View {
    @StateObject var dataManager: DataManager = DataManager(notificationManager: NotificationManager())
    var entry: Provider.Entry
    var tasks: [TaskEntity] {
        return dataManager.fetchTasks().filter({ !$0.completion }).reversed()
    }

    var body: some View {
        ZStack {
            Color("WidgetBackground")
            
            if !tasks.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(tasks.prefix(5)) { task in
                        Link(destination: URL(string: "myapp://todo/\(task.id!)")!) {
                            HStack {
                                Image(systemName: "square")
                                    .scaleEffect(0.7)
                                    .opacity(0.8)
                                
                                Text(task.title ?? "")
                                    .font(.callout)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .overlay {
                    taskCount
                }
            } else {
                Text("No tasks")
                    .font(.callout)
            }
        }
    }
}

extension TaskManagerWidgetEntryView {
    var taskCount: some View {
        HStack {
            Text("\(tasks.count)")
                .bold()
                .foregroundColor(.white)
                .frame(width: 40, height: 25)
                .background(Color("ButtonColor"))
                .clipShape(Capsule())
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

