//
//  BiometryManager.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 16.04.2023.
//

import Foundation
import LocalAuthentication

class BiometryManager {
    static func getBiometryType() -> String {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if #available(iOS 11.0, *) {
                return context.biometryType == .faceID ? "faceid" : "touchid"
            } else {
                return "touchid"
            }
        }
        return ""
    }
}
