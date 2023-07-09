//
//  EditView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
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
            TitleTextField(taskTitle: $taskTitle, task: task)
                .focused($titleFocus)
                .onChange(of: titleFocus) {
                    vm.titleFocus = $0
                }
                .onChange(of: vm.titleFocus) {
                    titleFocus = $0
                }
            
            Divider()
            
            NotesField(taskNotes: $taskNotes, task: task)
                .focused($textEditorFocus)
                .onChange(of: textEditorFocus) {
                    vm.textEditorFocus = $0
                }
                .onChange(of: vm.textEditorFocus) {
                    textEditorFocus = $0
                }
            
            ZStack {
                NotificationToggle(notification: $notification, task: task)
                    .offset(x: vm.textEditorFocus ? -UIScreen.main.bounds.width : 0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.textEditorFocus)
                
                AccentButton(label: "EditViewDoneButton-string".localized, action: {
                    vm.textEditorFocus = false
                })
                .offset(x: vm.textEditorFocus ? 0 : UIScreen.main.bounds.width)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.textEditorFocus)
            }
            
            if notification {
                NotificationOptions(date: $date, task: task, spacingValue: spacingValue)
                    .offset(y: vm.textEditorFocus ? UIScreen.main.bounds.height / 2 : 0)
                    .offset(y: vm.titleFocus ? UIScreen.main.bounds.height / 2 : 0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.textEditorFocus)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.titleFocus)
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
        .background(Color.backgroundColor)
        .frame(minHeight: 0, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            if vm.showSearch {
                withAnimation {
                    vm.showSearch = false
                    vm.searchable = ""
                    vm.searchKeyboardFocus = false
                }
            }
            Task {
                await NotificationManager.instance.removeDelivered(task, vm)
            }
        }
        .onDisappear {
            vm.textEditorFocus = false
        }
    }
}

struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager()
        let vm = TaskManagerViewModel(dataManager: dataManager)
        EditView(task: vm.dataManager.allTasks[0])
            .environmentObject(TaskManagerViewModel(dataManager: dataManager))
    }
}
