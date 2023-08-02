//
//  AppDelegate.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 14.03.2023.
//

import Foundation
import UserNotifications
import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let options: UNAuthorizationOptions = [.alert, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: options) { (succes, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("Success authorization")
            }
        }
                
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let dataManager = DataManager(notificationManager: NotificationManager())
        let identifier = response.notification.request.identifier
        guard let task = dataManager.allTasks.first(where: { $0.id == identifier }) else { return }
        print(task.title!)
        completionHandler()
    }    
}
