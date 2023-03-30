//
//  HapticManager.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 16.03.2023.
//

import Foundation
import UIKit

class HapticManager {
    
    static let instance = HapticManager()
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func errorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
