//
//  TaskManagerWidget.swift
//  TaskManagerWidget
//
//  Created by Egor Bubiryov on 30.07.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct TaskManagerWidget: Widget {
    let kind: String = "TaskManagerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TaskManagerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("Don't forget any important task.")
        .supportedFamilies([.systemMedium])
    }
}

struct TaskManagerWidget_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagerWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
