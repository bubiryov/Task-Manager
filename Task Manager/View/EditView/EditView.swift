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
        _taskTitle = State(initialValue: task.title!)
        _taskNotes = State(initialValue: task.notes!)
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
        let vm = TaskManagerViewModel()
        EditView(task: vm.allTasks[0])
            .environmentObject(TaskManagerViewModel())
    }
}

//struct NotesField: View {
//    
//    @EnvironmentObject var vm: TaskManagerViewModel
//    @Binding var taskNotes: String
//    var task: TaskEntity
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Notes:")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            
//            TextEditor(text: $taskNotes)
//                .tint(.tabBarColor)
//                .padding(5)
//                .font(.system(size: 23))
//                .scrollContentBackground(.hidden)
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(10)
//                .foregroundColor(.primary)
//                .onChange(of: taskNotes) { newValue in
//                    task.notes = newValue
//                    task.completion = false
//                    vm.toSave()
//                }
//        }
//        .frame(maxHeight: UIScreen.main.bounds.height / 5)
//    }
//}

//struct NotificationToggle: View {
//    
//    @EnvironmentObject var vm: TaskManagerViewModel
//    @Binding var notification: Bool
//    var task: TaskEntity
//        
//    var body: some View {
//        Toggle(isOn: $notification.animation()) {
////            Text(task.dateLabel! == "" ? "Notification" : task.dateLabel!)
//            Text("Some date")
//        }
//        .tint(.tabBarColor)
//        .onChange(of: notification) { _ in
//            UIApplication.shared.endEditing(true)
//            if task.notification {
//                Task {
//                    await NotificationManager.instance.removeRequest(task, vm)
//                }
//            }
//        }
//    }
//}

//struct TitleTextField: View {
//    
//    @EnvironmentObject var vm: TaskManagerViewModel
//    @Binding var taskTitle: String
//    var task: TaskEntity
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            TextField("Write your task", text: $taskTitle)
//                .font(.title)
//                .bold()
//                .onChange(of: taskTitle) { newValue in
//                    task.title = newValue
//                    task.completion = false
//                    vm.toSave()
//                }
//                .minimumScaleFactor(0.65)
//                .frame(height: 7)
//        }
//    }
//}

//struct NotificationOptions: View {
//    
//    @EnvironmentObject var vm: TaskManagerViewModel
//    @Binding var date: Date
//    var task: TaskEntity
//    var spacingValue: CGFloat
//    
//    var body: some View {
//        VStack(spacing: spacingValue) {
//            DatePicker("Date", selection: $date, in: date..., displayedComponents: [.date, .hourAndMinute])
//                .environment(\.locale, Locale(identifier: "ua_UA"))
//                .tint(.tabBarColor)
//            
//            Button {
//                Task {
//                    await NotificationManager.instance.addNotification(task: task, vm: vm, date: date)
//                    task.completion = false
//                }
//            } label: {
//                Text("Notification")
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 7)
//                    .background(Color.tabBarColor)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//            }
//        }
//    }
//}
