//
//  SearchButton.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct SearchButton: View {
    
    @ObservedObject var dataManager: DataManager
    @ObservedObject var interfaceData: InterfaceData
        
    var body: some View {
        
        let inMainList = dataManager.allTasks.filter { $0.inRecent == false }
        
        Button {
            withAnimation(.easeOut(duration: 0.2)) {
                if !inMainList.isEmpty {
                    HapticManager.instance.impact(style: .light)
                    withAnimation(.easeInOut(duration: 0.15)) {
                        interfaceData.showSearch.toggle()
                    }
                    interfaceData.searchable = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if interfaceData.searchKeyboardFocus {
                            UIApplication.shared.endEditing(true)
                            interfaceData.searchKeyboardFocus = false
                        } else {
                            interfaceData.searchKeyboardFocus = true
                        }
                    }
                } else {
                    HapticManager.instance.errorHaptic()
                }
            }
        } label: {
            Image(systemName: "magnifyingglass")
                .bold()
        }
        .tint(.primary)
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton(
            dataManager: DataManager(notificationManager: NotificationManager()),
            interfaceData: InterfaceData(
                dataManager: DataManager(notificationManager: NotificationManager()),
                biometryManager: BiometryManager()))
    }
}
