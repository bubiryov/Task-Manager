//
//  FocusStateViewModel.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 12.03.2023.
//

import Foundation
import SwiftUI

enum FocusState {
    case none
    case focusedTextField
}

class FocusStateViewModel: ObservableObject {
    @Published private var focusState: FocusState = .none

    func setFocusState(_ focusState: FocusState?) {
        self.focusState = focusState ?? .none
    }

    func getFocusState() -> FocusState {
        focusState
    }
}
