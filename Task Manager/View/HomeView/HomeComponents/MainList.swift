//
//  MainList.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct MainList: View {
    
    @ObservedObject var interfaceData: InterfaceData
    @ObservedObject var dataManager: DataManager
    
    var body: some View {
        
        let mainTasks = dataManager.allTasks.filter { $0.inRecent == false }
        
        List {
            ForEach(mainTasks.reversed().filter { task in
                interfaceData.searchable.isEmpty ? true : task.title?.localizedCaseInsensitiveContains(interfaceData.searchable) == true
            }) { task in
                NavigationLink {
                    EditView(task: task)
                } label: {
                    TaskRow(task: task, dataManager: dataManager)
                }
            }
            .onDelete(perform: { indexSet in
                dataManager.deleteTask(indexSet: indexSet, recentList: false)
            })
            .listRowSeparator(.hidden)
            .listRowBackground(Color.backgroundColor)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.inset)
        .background(Color.backgroundColor)
        .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
        .padding(.top, 1)
    }
}

struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        MainList(
            interfaceData: InterfaceData(
                dataManager: DataManager(notificationManager: NotificationManager()),
                biometryManager: BiometryManager()),
            dataManager: DataManager(notificationManager: NotificationManager())
        )
    }
}
