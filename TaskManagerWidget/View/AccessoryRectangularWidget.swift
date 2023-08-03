//
//  AccessoryRectangularWidget.swift
//  TaskManagerWidgetExtension
//
//  Created by Egor Bubiryov on 03.08.2023.
//

import SwiftUI

struct AccessoryRectangularWidget: View {
    
    var tasks: [TaskEntity]
    
    var body: some View {
        VStack(alignment: .leading) {
            if !tasks.isEmpty {
                ForEach(tasks.prefix(3)) { task in
                    HStack {
                        Image(systemName: "square")
                            .scaleEffect(0.7)
                        Text(task.title ?? "")
                    }
                }
            } else {
                Text("No tasks")
            }
        }
    }
}
