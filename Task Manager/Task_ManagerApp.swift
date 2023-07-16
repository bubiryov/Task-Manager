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
    
    @StateObject var csManager = ColorSchemeManager()
    @StateObject var vm: TaskManagerViewModel = TaskManagerViewModel()
                
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .environmentObject(csManager)
                .onAppear {
                    csManager.applyColorScheme()
                    vm.addToRecent()
                }
        }
    }
}



