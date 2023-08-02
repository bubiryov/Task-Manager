//
//  TitleTextField.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct TitleTextField: View {
    
    @ObservedObject var dataManager: DataManager
    @Binding var taskTitle: String
    var task: TaskEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("EditViewTitleTextField-string".localized, text: $taskTitle)
                .font(.title)
                .bold()
                .onChange(of: taskTitle) { newValue in
                    task.title = newValue
                    task.completion = false
                    dataManager.toSave()
                }
                .minimumScaleFactor(0.65)
                .frame(height: 7)
        }
    }
}

struct TitleTextField_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager(notificationManager: NotificationManager())
        TitleTextField(
            dataManager: dataManager,
            taskTitle: .constant("Some important task"),
            task: dataManager.allTasks[0]
        )
    }
}
