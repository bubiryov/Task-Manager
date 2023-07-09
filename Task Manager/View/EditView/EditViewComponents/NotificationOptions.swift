//
//  NotificationOptions.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct NotificationOptions: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    @Binding var date: Date
    var plusMinuteDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
    var task: TaskEntity
    var spacingValue: CGFloat
    
    var body: some View {
        VStack(spacing: spacingValue) {
            
            DatePicker("EditViewNotificationDate-string".localized,
                       selection: $date,
                       in: plusMinuteDate...,
                       displayedComponents: [.date, .hourAndMinute])
                .environment(\.locale, Locale.autoupdatingCurrent)
                .tint(.tabBarColor)
                .onAppear {
                    let formatter = DateFormatter()
                    formatter.locale = Locale.autoupdatingCurrent
                    if Locale.current.language.languageCode?.identifier == "ru" {
                        formatter.calendar = Calendar(identifier: .iso8601)
                        formatter.dateFormat = "dd.MM.yyyy HH:mm"
                        UIDatePicker.appearance().locale = Locale(identifier: "ru_RU")
                    } else {
                        formatter.calendar = Calendar(identifier: .gregorian)
                        formatter.dateFormat = "MMM d, yyyy h:mm a"
                    }
                    UIDatePicker.appearance().calendar = formatter.calendar
                    UIDatePicker.appearance().datePickerMode = .dateAndTime
                }
            
            AccentButton(label: "EditViewNotificationButton-string".localized) {
                Task {
                    await NotificationManager.instance.addNotification(task: task, vm: vm, date: date)
                    task.completion = false
                }
            }
        }
    }
}

struct NotificationOptions_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager()
        NotificationOptions(
            date: .constant(Date()),
            task: TaskManagerViewModel(dataManager: dataManager).dataManager.allTasks[0],
            spacingValue: 30)
        .environmentObject(TaskManagerViewModel(dataManager: dataManager))
    }
}

