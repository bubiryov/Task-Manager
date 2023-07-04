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
