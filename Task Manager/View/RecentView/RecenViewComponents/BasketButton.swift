//
//  BasketButton.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct BasketButton: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    @State private var showAlert: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            if vm.dataManager.allTasks.filter({ $0.inRecent }).count > 0 {
                HapticManager.instance.impact(style: .light)
                showAlert = true
            } else {
                HapticManager.instance.errorHaptic()
            }
        } label: {
            Image(systemName: "trash")
                .foregroundColor(.red.opacity(0.8))
                .bold()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("RecentAlertTitle-string"),
                  message: Text("RecentAlertMessage-string"),
                  primaryButton:
                    .destructive(Text("RecentAlertPrimaryButton-string")) {
                        vm.deleteAllRecent()
                    },
                  secondaryButton: .cancel())
        }
    }
}

struct BasketButton_Previews: PreviewProvider {
    static var previews: some View {
        BasketButton()
            .environmentObject(TaskManagerViewModel(dataManager: DataManager()))
    }
}
