//
//  NotesField.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct NotesField: View {
    
    @ObservedObject var dataManager: DataManager
    @Binding var taskNotes: String
    var task: TaskEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("AddNotesTextEditor-string")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextEditor(text: $taskNotes)
                .tint(.tabBarColor)
                .padding(5)
                .font(.system(size: 18))
                .scrollContentBackground(.hidden)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.primary)
                .onChange(of: taskNotes) { newValue in
                    task.notes = newValue
                    task.completion = false
                    dataManager.toSave()
                }
        }
        .frame(maxHeight: UIScreen.main.bounds.height / 5)
    }
}

struct NotesField_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager(notificationManager: NotificationManager())
        NotesField(
            dataManager: dataManager,
            taskNotes: .constant(""),
            task: dataManager.allTasks[0]
        )
    }
}
