//
//  Task_ManagerApp.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

/*
 Не работает:
 1. Счетчик бейджей
 2. Переход по уведомлению (перестают работать некоторые асинхронные функции)
*/

import SwiftUI

@main
struct Task_ManagerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var dataManager: DataManager
    @StateObject var colorSchemeManager = ColorSchemeManager()
    @StateObject var interfaceData: InterfaceData

    let notificationManager: NotificationManager = NotificationManager()
    let biometryManager: BiometryManager = BiometryManager()
    
    init() {
        let dataManager = DataManager(notificationManager: notificationManager)
        let interfaceData = InterfaceData(dataManager: dataManager, biometryManager: biometryManager)
        
        _dataManager = StateObject(wrappedValue: dataManager)
        _interfaceData = StateObject(wrappedValue: interfaceData)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(colorSchemeManager)
                .environmentObject(dataManager)
                .environmentObject(interfaceData)
                .onAppear {
                    colorSchemeManager.applyColorScheme()
                    dataManager.addToRecent()
                }
        }
    }
}



