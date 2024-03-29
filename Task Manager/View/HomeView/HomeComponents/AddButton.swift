//
//  AddButton.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct AddButton: View {
    
    @ObservedObject var interfaceData: InterfaceData
    @Binding var showAddWindow: Bool

    var body: some View {
        Button {
            HapticManager.instance.impact(style: .light)
            showAddWindow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                interfaceData.titleKeyboardFocus = true
            }
        } label: {
            Text("+")
                .foregroundColor(.white)
                .font(.system(size: 40))
        }
        .frame(width: 70, height: 70)
        .background(Color.tabBarColor)
        .clipShape(Circle())
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton(
            interfaceData: InterfaceData(
                dataManager: DataManager(notificationManager: NotificationManager()),
                biometryManager: BiometryManager()),
            showAddWindow: .constant(false))
    }
}
