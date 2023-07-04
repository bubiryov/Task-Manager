//
//  MainList.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct MainList: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    
    var body: some View {
        
        let mainTasks = vm.dataManager.allTasks.filter { $0.inRecent == false }
        
        List {
            ForEach(mainTasks.reversed().filter { task in
                vm.searchable.isEmpty ? true : task.title?.localizedCaseInsensitiveContains(vm.searchable) == true
            }) { task in
                NavigationLink {
                    EditView(task: task)
                } label: {
                    TaskRow(task: task)
                }
            }
            .onDelete(perform: vm.deleteTask)
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
        MainList()
            .environmentObject(TaskManagerViewModel())
    }
}
