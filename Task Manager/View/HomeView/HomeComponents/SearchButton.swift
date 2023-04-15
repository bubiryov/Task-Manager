//
//  SearchButton.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct SearchButton: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
        
    var body: some View {
        
        let inMainList = vm.allTasks.filter { $0.inRecent == false }
        
        Button {
            withAnimation(.easeOut(duration: 0.2)) {
                if !inMainList.isEmpty {
                    HapticManager.instance.impact(style: .light)
                    withAnimation {
                        vm.showSearch.toggle()
                    }
                    vm.searchable = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if vm.searchKeyboardFocus {
                            UIApplication.shared.endEditing(true)
                            vm.searchKeyboardFocus = false
                        } else {
                            vm.searchKeyboardFocus = true
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
        SearchButton()
            .environmentObject(TaskManagerViewModel())
    }
}
