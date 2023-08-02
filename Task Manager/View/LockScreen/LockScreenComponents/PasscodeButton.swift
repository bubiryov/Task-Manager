//
//  PasscodeButton.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI
import LocalAuthentication

struct PasscodeButton: View {
    
    @ObservedObject var interfaceData: InterfaceData
    @Binding var passcode: String
    var value: String
    
    var body: some View {
        Button {
            tapButton()
        } label: {
            Circle()
                .fill(Color.tabBarColor)
                .frame(width: 80)
                .overlay {
                    if value != interfaceData.biometryType {
                        Text(value)
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                            .bold()
                    } else {
                        Image(systemName: interfaceData.biometryType)
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                    }
                }
        }
    }
    
    private func tapButton() {
        HapticManager.instance.impact(style: .light)
        switch value {
        case "⌫" :
            if passcode.count >= 1 {
                passcode.removeLast()
            }
        case interfaceData.biometryType : toAuthenticate()
        default:
            if passcode.count < interfaceData.passcode.count {
                passcode.append(value)
                if passcode.count == interfaceData.passcode.count {
                    toUnlock()
                }
            }
        }
    }
    
    func toUnlock() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if passcode == interfaceData.passcode {
                interfaceData.isUnlocked = true
                passcode = ""
                interfaceData.attempts = 0
            } else {
                withAnimation {
                    HapticManager.instance.errorHaptic()
                    passcode = ""
                    interfaceData.attempts += 1
                }
            }
        }
    }
    
    func toAuthenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && interfaceData.biometryIsOn {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "BiometricReason-string".localized) { success, authenticationError in
                if success {
                    passcode = interfaceData.passcode
                    toUnlock()
                } else {
                    print("Error of authentication")
                }
            }
        } else {
            print("Device has not biometrics")
        }
    }
}

struct PasscodeButton_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeButton(
            interfaceData: InterfaceData(
                dataManager: DataManager(notificationManager: NotificationManager()),
                biometryManager: BiometryManager()),
            passcode: .constant("0000"), value: "1")
    }
}
