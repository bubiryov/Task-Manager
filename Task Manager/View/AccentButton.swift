//
//  AccentButton.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 21.03.2023.
//

import SwiftUI

struct AccentButton: View {

    var label: String
    var action: () -> Void
    var asyncAction: () async -> Void

    var body: some View {
        Button(action: {
            HapticManager.instance.impact(style: .light)
            Task {
                await asyncAction()
            }
            action()
        }, label: {
            Text(label)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 7)
                .background(Color.tabBarColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        })
    }

    init(label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
        self.asyncAction = { }
    }

    init(label: String, asyncAction: @escaping () async -> Void) {
        self.label = label
        self.action = { }
        self.asyncAction = asyncAction
    }
}

struct AccentButton_Previews: PreviewProvider {
    static var previews: some View {
        AccentButton(label: "Done", action: { print("") })
    }
}
