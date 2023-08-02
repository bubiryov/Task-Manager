//
//  HomeView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var interfaceData: InterfaceData
    @EnvironmentObject var dataManager: DataManager
    
    @State private var tittle = ""
    @State private var notes = ""
    @State private var showAddWindow = false
    @State private var readyToNavigate = false
    @State private var task: TaskEntity?
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    VStack {

                        if interfaceData.showSearch {
                            SearchTextField(interfaceData: interfaceData)
                        }
                        
                        if !dataManager.allTasks.isEmpty {
                            MainList(
                                interfaceData: interfaceData,
                                dataManager: dataManager
                            )
                        }
                                                
                        Spacer()
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        AddButton(
                            interfaceData: interfaceData,
                            showAddWindow: $showAddWindow
                        )
                        .offset(y: UIScreen.main.bounds.height * 0.28)
                        .padding(.bottom, 100)
                        .padding(.trailing)
                    }
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SearchButton(
                            dataManager: dataManager,
                            interfaceData: interfaceData
                        )
                    }
                })
                .navigationTitle("HomeViewTitle-string")
                .background(Color.backgroundColor)
                .ignoresSafeArea(.keyboard)
                .navigationDestination(isPresented: $readyToNavigate) {
                    if let task {
                        EditView(task: task)
                    }
                }
            }
            .tint(.primary)
            .blur(radius: showAddWindow ? 10 : 0)
            .ignoresSafeArea()
            
            AddWindow(
                interfaceData: interfaceData,
                dataManager: dataManager,
                showWindow: $showAddWindow
            )
            .offset(y: showAddWindow ? 0 : -UIScreen.main.bounds.height)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showAddWindow)
        }
        .background(Color.backgroundColor)
        .onOpenURL { url in
            guard
                url.scheme == "myapp",
                url.host == "todo",
                let id = url.pathComponents.last else {
                print("Fail guard")
                return
            }
            task = dataManager.allTasks.first(where: { $0.id == id })
            if task != nil {
                readyToNavigate = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(
                InterfaceData(
                    dataManager: DataManager(notificationManager: NotificationManager()),
                    biometryManager: BiometryManager()))
            .environmentObject(DataManager(notificationManager: NotificationManager()))
    }
}
