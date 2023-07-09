//
//  SettingsView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 02.03.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    @EnvironmentObject var csManager: ColorSchemeManager
    
    @State private var showSheet = false
    @State private var toggleBlock = false
    @State private var showNotificationsAlert = false
    @State private var showTasksAlert = false
    @State private var showAttemptsAlert = false

    
//    init() {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.primary)]
//    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    Picker("", selection: $csManager.colorScheme) {
                        Text("SchemePickerSystem-string").tag(ColorScheme.system)
                        Text("SchemePickerLight-string").tag(ColorScheme.light)
                        Text("SchemePickerDark-string").tag(ColorScheme.dark)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: csManager.colorScheme) { _ in
                        HapticManager.instance.impact(style: .light)
                    }
                    
                    Toggle(isOn: $toggleBlock.animation()) {
                        Text("Passcode-string")
                    }
                    .tint(Color.tabBarColor)
                    .onChange(of: toggleBlock, perform: { newValue in
                        if vm.block != toggleBlock {
                            showSheet = true
                        }
                    })
                    .onAppear {
                        toggleBlock = vm.block
                    }
                    .sheet(isPresented: $showSheet) {
                        SheetView(toggleBlock: $toggleBlock)
                    }
                    
                    Toggle(isOn: $vm.toCountAttempts) {
                        Text("AttemptsCountToggle-string")
                    }
                    .tint(Color.tabBarColor)
                    .onChange(of: vm.toCountAttempts) { _ in
                        if vm.toCountAttempts && vm.block {
                            showAttemptsAlert = true
                        } else {
                            vm.toCountAttempts = false
                        }
                    }
                    .alert(isPresented: $showAttemptsAlert) {
                        Alert(
                            title: Text("AttemptsToggleAlertTitle-string"),
                            message: Text("AttemptsToggleAlertMessage-string"),
                            dismissButton: .default(Text("AlertOKButton-string")))
                    }
                    
                    Toggle(isOn: $vm.biometryIsOn) {
                        Text(vm.biometryType == "touchid" ? "Touch ID" : "Face ID")
                    }
                    .tint(Color.tabBarColor)                    
                    
                    Button {
                        showNotificationsAlert = true
                    } label: {
                        Text("CancelAllNotifications-string")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showNotificationsAlert) {
                        Alert(title: Text("CancelAllNotificationsTitle-string"),
                              primaryButton:
                                .destructive(Text("CancelAllPrimaryButton-string")) {
                                    NotificationManager.instance.cancelAll(vm)
                                },
                              secondaryButton: .cancel())
                    }
                    
                    Button {
                        showTasksAlert = true
                    } label: {
                        Text("DeleteAllTasks-string")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showTasksAlert) {
                        Alert(title: Text("DeleteAllTasksTitle-string"),
                              primaryButton:
                                .destructive(Text("DeleteAllTasksButton-string")) {
                                    vm.deleteAllTasks()
                                },
                              secondaryButton: .cancel())
                    }
                                                            
                    Spacer()
                }
                .navigationTitle("SettingsTitle-string")
                .padding(.horizontal)
                .padding(.top)
            }
            .background(Color.backgroundColor)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(TaskManagerViewModel(dataManager: DataManager()))
            .environmentObject(ColorSchemeManager())
    }
}
