//
//  LockScreen.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 18.03.2023.
//

import SwiftUI
import LocalAuthentication

struct LockScreen: View {
    
    @State private var passcode: String = ""
    @EnvironmentObject var vm: TaskManagerViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                HStack(spacing: 22) {
                    ForEach(0..<vm.passcode.count, id: \.self) { index in
                        PasscodeCircles(index: index, passcode: $passcode)
                    }
                }
                .modifier(ShakeEffect(animatableData: CGFloat(vm.attempts)))
                
                Spacer()
                
                if (1...4).contains(vm.attempts) && vm.toCountAttempts {
                    Text("AttemptsCount-string".localized + "\(5-vm.attempts)")
                        .padding(.bottom, 20)
                        .foregroundColor(.red)
                } else if vm.attempts >= 5 && vm.toCountAttempts {
                    Text("DeletedData-string")
                        .padding(.bottom, 20)
                        .foregroundColor(.red)
                } else if vm.attempts == 0 || !vm.toCountAttempts {
                    Text(" ")
                        .padding(.bottom, 20)
                }

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: 3),
                    spacing: 10){
                        ForEach(1...9, id: \.self) { value in
                            PasscodeButton(passcode: $passcode, value: "\(value)")
                        }
                        PasscodeButton(passcode: $passcode, value: "⌫")
                        PasscodeButton(passcode: $passcode, value: "0")
                        PasscodeButton(passcode: $passcode, value: vm.biometryType)
                        
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
            .background(Color.backgroundColor)
            .onAppear {
                vm.getBiometryType()
            }

            
//            .toolbar {
//                MenuView()
//            }
        }
    }
}

struct LockScreen_Previews: PreviewProvider {
    static var previews: some View {
        LockScreen()
            .environmentObject(TaskManagerViewModel())
    }
}

