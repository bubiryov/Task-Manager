//
//  HomeView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: TaskManagerViewModel
    
    @State private var tittle = ""
    @State private var notes = ""
    @State private var showAddWindow = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack {
                        if vm.showSearch {
                            SearchTextField()
                        }
                        MainList()
                        
                        Spacer()
                    }
                    
                    AddButton(showAddWindow: $showAddWindow)
                        .offset(y: UIScreen.main.bounds.height * 0.28)
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SearchButton()
                    }
                })
                .navigationTitle("HomeViewTitle-string")
                .background(Color.backgroundColor)
                .ignoresSafeArea(.keyboard)

            }
            .tint(.primary)
            .blur(radius: showAddWindow ? 10 : 0)
            .ignoresSafeArea()
            
            AddWindow(showWindow: $showAddWindow)
                .offset(y: showAddWindow ? 0 : -UIScreen.main.bounds.height)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showAddWindow)
            
//            Button {
//                vm.deleteAllTasks()
//            } label: {
//                Text("Delete")
//            }
//
        }
        .background(Color.backgroundColor)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TaskManagerViewModel())
    }
}

//struct AddButton: View {
//    @EnvironmentObject var vm: TaskManagerViewModel
//    @Binding var showAddWindow: Bool
//
//    var body: some View {
//        Button {
//            HapticManager.instance.impact(style: .light)
//            showAddWindow = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                vm.titleKeyboardFocus = true
//            }
//        } label: {
//            Circle()
//                .overlay {
//                    Text("+")
//                        .foregroundColor(.white)
//                        .font(.system(size: 40))
//                }
//        }
//        .foregroundColor(.tabBarColor)
//        .frame(width: 70)
//        .padding(.bottom, 100)
//        .padding(.trailing)
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
////        .ignoresSafeArea(.keyboard)
//    }
//}

//struct TaskRow: View {
//    var task: TaskEntity
//    @EnvironmentObject var vm: TaskManagerViewModel
//    var body: some View {
//        HStack {
//            Image(systemName: task.completion ? "checkmark.square.fill" : "square")
//                .foregroundColor(task.completion ? .tabBarColor : .primary)
//                .font(.system(size: 23))
//                .onTapGesture {
//                    withAnimation(.linear(duration: 0.1)) {
//                        vm.updateTask(task: task)
//                        Task {
//                            await NotificationManager.instance.removeRequest(task, vm)
//                            task.dateLabel = ""
//                            task.notification = false
//                            vm.toSave()
//                        }
//                    }
//                }
//
//            Text(task.title ?? "")
//                .opacity(task.completion ? 0.4 : 1)
//                .font(.title2)
//                .lineLimit(1)
//                .padding(.leading, 5)
//                .foregroundColor(.primary)
//
//            if task.notes != "" {
//                Image(systemName: "doc")
//                    .foregroundColor(.secondary)
//                    .font(.system(size: 15))
//            }
//
//            if task.notification {
//                Image(systemName: "bell.badge")
//                    .foregroundColor(.secondary)
//                    .font(.system(size: 15))
//            }
//        }
//        .padding(.vertical, 5)
//    }
//}

//struct SearchTextField: View {
//    
//    @EnvironmentObject var vm: TaskManagerViewModel
//    @FocusState var focus: Bool
//    
//    var body: some View {
//        
//        TextField("Search", text: $vm.searchable)
//            .padding()
//            .disableAutocorrection(true)
//            .background(Color.tabBarColor.opacity(0.3))
//            .cornerRadius(20)
//            .padding(.horizontal)
//            .focused($focus)
//            .onChange(of: vm.searchKeyboardFocus) {
//                focus = $0
//            }
//    }
//}

//struct SearchButton: View {
//    @EnvironmentObject var vm: TaskManagerViewModel
//    var body: some View {
//        Button {
//            withAnimation(.easeOut(duration: 0.2)) {
//                if !vm.allTasks.isEmpty {
//                    HapticManager.instance.impact(style: .light)
//                    withAnimation {
//                        vm.showSearch.toggle()
//                    }
//                    vm.searchable = ""
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        if vm.searchKeyboardFocus {
//                            UIApplication.shared.endEditing(true)
//                            vm.searchKeyboardFocus = false
//                        } else {
//                            vm.searchKeyboardFocus = true
//                        }
//                    }
//                } else {
//                    HapticManager.instance.errorHaptic()
//                }
//            }
//        } label: {
//            Image(systemName: "magnifyingglass")
//        }
//        .tint(.primary)
//    }
//}

//struct MainList: View {
//    @EnvironmentObject var vm: TaskManagerViewModel
//    var body: some View {
//        let mainTasks = vm.allTasks.filter { $0.inRecent == false }
//        List {
//            ForEach(mainTasks.reversed().filter { task in
//                vm.searchable.isEmpty ? true : task.title?.localizedCaseInsensitiveContains(vm.searchable) == true
//            }) { task in
//                NavigationLink {
//                    EditView(task: task)
//                } label: {
//                    TaskRow(task: task)
//                }
//            }
//            .onDelete(perform: vm.deleteTask)
//            .listRowSeparator(.hidden)
//            .listRowBackground(Color.backgroundColor)
//        }
//        .scrollContentBackground(.hidden)
//        .listStyle(.inset)
//        .background(Color.backgroundColor)
//        .frame(maxHeight: UIScreen.main.bounds.height * 0.66)
//        .padding(.top)
//    }
//}
