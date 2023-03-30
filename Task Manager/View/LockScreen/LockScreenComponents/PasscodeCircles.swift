//
//  PasscodeCircles.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct PasscodeCircles: View {
    
    var index: Int
    @Binding var passcode: String
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(Color.primary, lineWidth: 3)
                .frame(width: 20, height: 20)
            
            if passcode.count > index {
                Circle()
                    .fill(Color.tabBarColor)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct PasscodeCircles_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeCircles(index: 0, passcode: .constant("0000"))
    }
}
