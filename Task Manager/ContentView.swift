//
//  ContentView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .house
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var vm: TaskManagerViewModel
        
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    if selectedTab == .house {
                        HomeView()
                    } else if selectedTab == .recent {
                        RecentView()
                    } else {
                        SettingsView()
                    }
                }
                .animation(nil, value: selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                TabBar(selectedTab: $selectedTab)
                    .offset(y: UIScreen.main.bounds.height * 0.41)
                
                LockScreen()
                    .offset(y: !vm.isUnlocked && vm.block ? 0 : -UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 0.3), value: vm.isUnlocked)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager()
        ContentView()
            .environmentObject(TaskManagerViewModel(dataManager: dataManager))
            .environmentObject(ColorSchemeManager())
            .environmentObject(dataManager)
    }
}
