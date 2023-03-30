//
//  NotificationDelegate.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 13.03.2023.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    @ObservedObject var vm = TaskManagerViewModel()
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let identifier = response.notification.request.identifier
//        if let task = vm.allTasks.first(where: { $0.id == identifier }) {
//            // Код
//        }
//        completionHandler()
//    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let identifier = response.notification.request.identifier
//        if let task = vm.allTasks.first(where: { $0.id == identifier }) {
//            Task {
//                await withUnsafeContinuation { continuation in
//                    UIApplication.shared.applicationIconBadgeNumber -= 1
//                    task.notification = false
//                    task.dateLabel = ""
//                    vm.toSave()
//                    continuation.resume()
//                }
//            }
//        }
//    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//        let identifier = response.notification.request.identifier
//        if let task = vm.allTasks.first(where: { $0.id == identifier }) {
//            await withUnsafeContinuation { continuation in
//                Task {
//                    await NotificationManager.instance.removeDelivered(task, vm)
//                    continuation.resume()
//                }
//            }
//        }
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        DispatchQueue.main.async {
            NotificationManager.instance.cancelAll(self.vm)

        }
        completionHandler()
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        return true
    }






    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
