//
//  TaskManagerViewModel.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import Foundation
import SwiftUI
import CoreData

class InterfaceData: ObservableObject {
    
    weak var dataManager: DataManager?
    weak var biometryManager: BiometryManager?
    
    init(dataManager: DataManager, biometryManager: BiometryManager) {
        self.dataManager = dataManager
        self.biometryManager = biometryManager
    }
    
    @AppStorage("attempts") var attempts = 0 {
        didSet {
            if attempts > 4 && toCountAttempts {
                dataManager?.deleteAllTasks()
            }
        }
    }

    @AppStorage("passcode") var passcode = ""
    @AppStorage("isLocked") var block = false

    @AppStorage("toCountAttempts") var toCountAttempts = false
    @AppStorage("biometry") var biometryIsOn = false
    
    @Published var isUnlocked = false
    @Published var biometryType = "touchid"
    
    @Published var showSearch = false
    @Published var searchable = ""
    
    @Published var titleKeyboardFocus: Bool = false
    @Published var searchKeyboardFocus: Bool = false
    @Published var titleFocus: Bool = false
    @Published var textEditorFocus: Bool = false
    
    func getBiometryType() {
        if let biometryManager {
            biometryType = biometryManager.getBiometryType()
        }
    }
}
