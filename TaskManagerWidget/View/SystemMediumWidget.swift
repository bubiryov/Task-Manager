//
//  SystemMediumWidget.swift
//  TaskManagerWidgetExtension
//
//  Created by Egor Bubiryov on 03.08.2023.
//

import SwiftUI

struct SystemMediumWidget: View {
    
    var tasks: [TaskEntity]
    
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

extension SystemMediumWidget {
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
