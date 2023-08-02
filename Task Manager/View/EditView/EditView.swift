//
//  EditView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var interfaceData: InterfaceData
    let notificationManager: NotificationManager = NotificationManager()
    
    @State private var taskTitle: String
    @State private var taskNotes: String
    @State private var notification: Bool
    @State private var date: Date = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
    @State private var spacingValue: CGFloat = UIScreen.main.nativeBounds.height * 0.016
    @FocusState var textEditorFocus: Bool
    @FocusState var titleFocus: Bool
    
    var task: TaskEntity
    
    init(task: TaskEntity) {
        self.task = task
        _taskTitle = State(initialValue: task.title ?? "")
        _taskNotes = State(initialValue: task.notes ?? "")
        _notification = State(initialValue: task.notification)
    }
    
    var body: some View {
        VStack(spacing: spacingValue) {
            TitleTextField(
                dataManager: dataManager,
                taskTitle: $taskTitle,
                task: task
            )
            .focused($titleFocus)
            .onChange(of: titleFocus) {
                interfaceData.titleFocus = $0
            }
            .onChange(of: interfaceData.titleFocus) {
                titleFocus = $0
            }
            
            Divider()
            
            NotesField(
                dataManager: dataManager,
                taskNotes: $taskNotes,
                task: task
            )
            .focused($textEditorFocus)
            .onChange(of: textEditorFocus) {
                interfaceData.textEditorFocus = $0
            }
            .onChange(of: interfaceData.textEditorFocus) {
                textEditorFocus = $0
            }
            
            ZStack {
                NotificationToggle(
                    dataManager: dataManager,
                    notificationManager: notificationManager,
                    notification: $notification,
                    task: task
                )
                .offset(x: interfaceData.textEditorFocus ? -UIScreen.main.bounds.width : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: interfaceData.textEditorFocus)
                
                AccentButton(label: "EditViewDoneButton-string".localized, action: {
                    interfaceData.textEditorFocus = false
                })
                .offset(x: interfaceData.textEditorFocus ? 0 : UIScreen.main.bounds.width)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: interfaceData.textEditorFocus)
            }
            
            if notification {
                NotificationOptions(
                    dataManager: dataManager,
                    notificationManager: notificationManager,
                    date: $date,
                    task: task,
                    spacingValue: spacingValue
                )
                .offset(y: interfaceData.textEditorFocus ? UIScreen.main.bounds.height / 2 : 0)
                .offset(y: interfaceData.titleFocus ? UIScreen.main.bounds.height / 2 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: interfaceData.textEditorFocus)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: interfaceData.titleFocus)
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
        .background(Color.backgroundColor)
        .frame(minHeight: 0, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            if interfaceData.showSearch {
                withAnimation {
                    interfaceData.showSearch = false
                    interfaceData.searchable = ""
                    interfaceData.searchKeyboardFocus = false
                }
            }
            Task {
                await notificationManager.removeDelivered(task, dataManager)
            }
        }
        .onDisappear {
            interfaceData.textEditorFocus = false
        }
    }
}

struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager(notificationManager: NotificationManager())
        EditView(task: dataManager.allTasks[0])
            .environmentObject(dataManager)
            .environmentObject(InterfaceData(
                dataManager: dataManager,
                biometryManager: BiometryManager()))
    }
}
