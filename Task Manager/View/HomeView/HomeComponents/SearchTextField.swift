//
//  SearchField.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct SearchTextField: View {
    
    @ObservedObject var interfaceData: InterfaceData
    @FocusState var focus: Bool
    
    var body: some View {
        
        TextField("HomeSearchTextField-string", text: $interfaceData.searchable)
            .padding()
            .disableAutocorrection(true)
            .background(Color.tabBarColor.opacity(0.3))
            .cornerRadius(20)
            .padding(.horizontal)
            .focused($focus)
            .onChange(of: interfaceData.searchKeyboardFocus) {
                focus = $0
            }
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(
            interfaceData: InterfaceData(
                dataManager: DataManager(notificationManager: NotificationManager()),
                biometryManager: BiometryManager()))
    }
}
