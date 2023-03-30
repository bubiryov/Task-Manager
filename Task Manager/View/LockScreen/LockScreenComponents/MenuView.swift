//
//  MenuView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 20.03.2023.
//

import SwiftUI

struct MenuView: View {
    
    var body: some View {
        Menu {
            Label {
                Text("Reset passcode")
            } icon: {
                Image(systemName: "key.fill")
            }
            .onTapGesture {
                //
            }
            
        } label: {
            Image(systemName: "questionmark.circle")
                .frame(width: 19)
                .foregroundColor(.primary)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
