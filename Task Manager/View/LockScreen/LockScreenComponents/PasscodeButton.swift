//
//  PasscodeButton.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI
import LocalAuthentication

struct PasscodeButton: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
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
                    if value != vm.biometryType {
                        Text(value)
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                            .bold()
                    } else {
                        Image(systemName: vm.biometryType)
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
        case vm.biometryType : toAuthenticate()
        default:
            if passcode.count < vm.passcode.count {
                passcode.append(value)
                if passcode.count == vm.passcode.count {
                    toUNnlock()
                }
            }
        }
    }
    
    func toUNnlock() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if passcode == vm.passcode {
                vm.isUnlocked = true
                passcode = ""
                vm.attempts = 0
            } else {
                withAnimation {
                    HapticManager.instance.errorHaptic()
                    passcode = ""
                    vm.attempts += 1
                }
            }
        }
    }
    
    func toAuthenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && vm.biometryIsOn {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "BiometricReason-string".localized) { success, authenticationError in
                if success {
                    passcode = vm.passcode
                    toUNnlock()
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
        PasscodeButton(passcode: .constant("0000"), value: "1")
            .environmentObject(TaskManagerViewModel())
    }
}
