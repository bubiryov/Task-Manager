//
//  ShakeEffect.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    
    var travelDistance: CGFloat = 10
    var numOfShakes : CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue (size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX: travelDistance * sin(animatableData * .pi * numOfShakes),
            y: 0))
    }
}
