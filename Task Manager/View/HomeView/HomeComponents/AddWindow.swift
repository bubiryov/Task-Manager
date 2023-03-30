//
//  AddView.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 03.03.2023.
//

import SwiftUI

struct AddWindow: View {
    
    @EnvironmentObject var vm: TaskManagerViewModel
    @State private var title: String = ""
    @State private var notes: String = ""
    @Binding var showWindow: Bool
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.00001)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    HapticManager.instance.impact(style: .light)
                    newTask()
                    UIApplication.shared.endEditing(true)
                    vm.titleKeyboardFocus = false
                }
 
            VStack(spacing: 30) {
                TextField("", text: $title)
                    .placeholder(when: title.isEmpty) {
                        Text("AddTitleTextField-string").foregroundColor(.white.opacity(0.3))
                    }
                    .font(.title)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .bold()
                    .focused($focus)
                    .onChange(of: vm.titleKeyboardFocus) {
                        focus = $0
                    }
                
                VStack(alignment: .leading) {
                    Text("AddNotesTextEditor-string")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    TextEditor(text: $notes)
                        .scrollContentBackground(.hidden)
                        .background(Color.white.opacity(0.2))
                        .frame(maxWidth: .infinity, maxHeight: 70, alignment: .topLeading)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                }
            }
            .frame(width: UIScreen.main.bounds.width*0.85, height: UIScreen.main.bounds.width*0.60)
            .background(Color.tabBarColor)
            .cornerRadius(30)
            .offset(y: -UIScreen.main.bounds.height * 0.17)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    func newTask() {
        showWindow = false
        guard !title.isEmpty else {
            notes = ""
            return
        }
        vm.addTask(title: title, note: notes)
        title = ""
        notes = ""
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddWindow(showWindow: .constant(false))
            .environmentObject(TaskManagerViewModel())
    }
}
