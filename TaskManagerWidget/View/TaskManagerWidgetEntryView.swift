//
//  TaskManagerWidgetEntryView.swift
//  TaskManagerWidgetExtension
//
//  Created by Egor Bubiryov on 02.08.2023.
//

import SwiftUI
import WidgetKit

struct TaskManagerWidgetEntryView : View {
    
    @Environment (\.widgetFamily) var widgetFamily
    @StateObject var dataManager: DataManager = DataManager(notificationManager: NotificationManager())
    var entry: Provider.Entry
    var tasks: [TaskEntity] {
        return dataManager.fetchTasks().filter({ !$0.completion }).reversed()
    }

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            SystemMediumWidget(tasks: tasks)
        case .accessoryRectangular:
            AccessoryRectangularWidget(tasks: tasks)
        default: Text("Not implemented")
        }
    }
}
