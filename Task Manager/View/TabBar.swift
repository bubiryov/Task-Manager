//
//  TabBar.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 02.03.2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case recent = "list.bullet.rectangle.portrait"
    case house = "house"
    case gear = "gearshape"
}

struct TabBar: View {
    
//    @EnvironmentObject var vm: TaskManagerViewModel
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Spacer()
                Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                    .font(.title)
                    .scaleEffect(selectedTab == tab ? 1.1 : 0.75)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            HapticManager.instance.impact(style: .light)
                            selectedTab = tab
                        }
                    }
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
        .frame(height: 60)
        .background(Color.tabBarColor)
        .cornerRadius(30)
        .padding()

    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedTab: .constant(.recent))
    }
}
