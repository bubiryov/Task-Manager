//
//  SearchField.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct SearchTextField: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    @FocusState var focus: Bool
    
    var body: some View {
        
        TextField("HomeSearchTextField-string", text: $vm.searchable)
            .padding()
            .disableAutocorrection(true)
            .background(Color.tabBarColor.opacity(0.3))
            .cornerRadius(20)
            .padding(.horizontal)
            .focused($focus)
            .onChange(of: vm.searchKeyboardFocus) {
                focus = $0
            }
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField()
            .environmentObject(TaskManagerViewModel())
    }
}
