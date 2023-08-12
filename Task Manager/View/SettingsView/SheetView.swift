//
//  SheetView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct SheetView: View {
    
    @ObservedObject var interfaceData: InterfaceData
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
                if interfaceData.block {
                    
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
                
                GADBannerViewController()
                    .frame(width: 320, height: 50, alignment: .center)                
            }
            .padding(.horizontal)
            .padding(.top, 70)
            .onDisappear {
                if !interfaceData.block {
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
        guard previuosPasscode == interfaceData.passcode else {
            alertTitle = "WrongPasscodeAlert-string".localized
            showAlert = true
            return
        }
        dismiss()
        interfaceData.toCountAttempts = false
        interfaceData.block = false
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
        interfaceData.passcode = newPasscode1
        interfaceData.isUnlocked = false
        interfaceData.block = true
        dismiss()
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(
            interfaceData: InterfaceData(
                dataManager: DataManager(notificationManager: NotificationManager()),
                biometryManager: BiometryManager()),
            toggleBlock: .constant(false))
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
