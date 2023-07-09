//
//  RecentView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 02.03.2023.
//

import SwiftUI

struct RecentView: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    
    var body: some View {
        let recentTasks = vm.dataManager.allTasks.filter { $0.inRecent == true }

        NavigationView {
            ZStack {
                Color.backgroundColor
                
                VStack {
                    List {
                        ForEach(recentTasks.reversed()) { task in
                            TaskRow(task: task)
                        }
                        .onDelete(perform: vm.deleteTask)
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
                    BasketButton()
                }
            }
        }
    }
}

struct RecentView_Previews: PreviewProvider {
    static var previews: some View {
        RecentView()
            .environmentObject(TaskManagerViewModel(dataManager: DataManager()))
    }
}

//struct BasketButton: View {
//    
//    @EnvironmentObject var vm: TaskManagerViewModel
//    @State private var showAlert: Bool = false
//    @Environment(\.colorScheme) var colorScheme
//    
//    var body: some View {
//        Button {
//            if vm.allTasks.filter({ $0.inRecent }).count > 0 {
//                HapticManager.instance.impact(style: .light)
//                showAlert = true
//            } else {
//                HapticManager.instance.errorHaptic()
//            }
//        } label: {
//            Image(systemName: "trash")
//                .foregroundColor(.red.opacity(0.8))
//                .bold()
//        }
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Are you sure you want to clear the list?"),
//                  message: Text("This action will not be undone"),
//                  primaryButton:
//                    .destructive(Text("Delete")) {
//                        vm.deleteAllRecent()
//                    },
//                  secondaryButton: .cancel())
//        }
//    }
//}
