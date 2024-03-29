//
//  RecentView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 02.03.2023.
//

import SwiftUI

struct RecentView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        let recentTasks = dataManager.allTasks.filter { $0.inRecent == true }

        NavigationView {
            ZStack {
                Color.backgroundColor
                
                VStack {
                    List {
                        ForEach(recentTasks.reversed()) { task in
                            TaskRow(task: task, dataManager: dataManager)
                        }
                        .onDelete(perform: { indexSet in
                            dataManager.deleteTask(indexSet: indexSet, recentList: true)
                        })

                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.backgroundColor)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.inset)
                    .background(Color.backgroundColor)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.66)
                    .padding(.top)
                    
                    Spacer()
                }
            }
            .navigationTitle("RecentTitle-string")
            .background(Color.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    BasketButton(dataManager: dataManager)
                }
            }
        }
    }
}

struct RecentView_Previews: PreviewProvider {
    static var previews: some View {
        RecentView()
            .environmentObject(DataManager(notificationManager: NotificationManager()))
    }
}
