//
//  SheetView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct SheetView: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var toggleBlock: Bool
    
    @State private var previuosPasscode = ""
    @State private var newPasscode1 = ""
    @State private var newPasscode2 = ""
    @State private var alertTitle = ""
        
    @State private var showPreviousPasscode = false
    @State private var showNewPasscode1 = false
    @State private var showNewPasscode2 = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
//                if vm.passcode != "" {
//                    PasscodeField(
//                        fieldLabel: "Previous passcode",
//                        enteredPasscode: $previuosPasscode,
//                        showPasscode: $showPreviousPasscode
//                    )
//                }
                if vm.block {
                    
                    PasscodeField(
                        fieldLabel: "PasscodeField-string".localized,
                        enteredPasscode: $previuosPasscode,
                        showPasscode: $showPreviousPasscode
                    )
                              
                    AccentButton(label: "TurnOffPasscode-string".localized) {
                        deletePasscode()
                    }
                    .alert(alertTitle, isPresented: $showAlert) {
                        Button("AlertOKButton-string", role: .cancel) {
                            previuosPasscode = ""
                        }
                    }
                    
                } else {
                    
                    PasscodeField(
                        fieldLabel: "NewPasscodeField-string".localized,
                        enteredPasscode: $newPasscode1,
                        showPasscode: $showNewPasscode1
                    )
                    
                    PasscodeField(
                        fieldLabel: "NewPasscodeField2-string".localized,
                        enteredPasscode: $newPasscode2,
                        showPasscode: $showNewPasscode2
                    )
                    
                    AccentButton(label: "ProtectWithPasscode-string".localized) {
                        makePasscode()
                    }
                    .alert(alertTitle, isPresented: $showAlert) {
                        Button("AlertOKButton-string", role: .cancel) {
                            newPasscode2 = ""
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top, 70)
            .onDisappear {
                if !vm.block {
                    toggleBlock = false
                } else {
                    toggleBlock = true
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationTitle("Passcode-string")
            .ignoresSafeArea(.keyboard)
        }
    }
    
    func deletePasscode() {
        guard previuosPasscode == vm.passcode else {
            alertTitle = "WrongPasscodeAlert-string".localized
            showAlert = true
            return
        }
        dismiss()
        vm.toCountAttempts = false
        vm.block = false
    }
    
    func makePasscode() {
        guard newPasscode1.count >= 4 && newPasscode1.count <= 8 else {
            alertTitle = "NewPasscodeLittersAlert-string".localized
            showAlert = true
            return
        }
        guard newPasscode1 == newPasscode2 else {
            alertTitle = "PasscodeMismatchAlert-string".localized
            showAlert = true
            return
        }
        vm.passcode = newPasscode1
        vm.isUnlocked = false
        vm.block = true
        dismiss()
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(toggleBlock: .constant(false))
            .environmentObject(TaskManagerViewModel(dataManager: DataManager()))
    }
}

struct PasscodeField: View {
    
    var fieldLabel: String
    @Binding var enteredPasscode: String
    @Binding var showPasscode: Bool
    
    var body: some View {
        HStack {
            if showPasscode {
                TextField(fieldLabel, text: $enteredPasscode)
                    .keyboardType(.numberPad)
                    .frame(height: 25)
                    .padding()
                    .disableAutocorrection(true)
                    .background(Color.tabBarColor.opacity(0.3))
                    .cornerRadius(20)
            } else {
                SecureField(fieldLabel, text: $enteredPasscode)
                    .keyboardType(.numberPad)
                    .frame(height: 25)
                    .padding()
                    .disableAutocorrection(true)
                    .background(Color.tabBarColor.opacity(0.3))
                    .cornerRadius(20)
            }
            
            Image(systemName: showPasscode ? "eye.fill" : "eye.slash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 35)
                .opacity(0.5)
                .onTapGesture {
                    showPasscode.toggle()
                }
        }
    }
}
