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
    @EnvironmentObject var interfaceData: InterfaceData
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                HStack(spacing: 22) {
                    ForEach(0..<interfaceData.passcode.count, id: \.self) { index in
                        PasscodeCircles(index: index, passcode: $passcode)
                    }
                }
                .modifier(ShakeEffect(animatableData: CGFloat(interfaceData.attempts)))
                
                Spacer()
                
                if (1...4).contains(interfaceData.attempts) && interfaceData.toCountAttempts {
                    Text("AttemptsCount-string".localized + "\(5 - interfaceData.attempts)")
                        .padding(.bottom, 20)
                        .foregroundColor(.red)
                } else if interfaceData.attempts >= 5 && interfaceData.toCountAttempts {
                    Text("DeletedData-string")
                        .padding(.bottom, 20)
                        .foregroundColor(.red)
                } else if interfaceData.attempts == 0 || !interfaceData.toCountAttempts {
                    Text(" ")
                        .padding(.bottom, 20)
                }

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: 3),
                    spacing: 10){
                        ForEach(1...9, id: \.self) { value in
                            PasscodeButton(
                                interfaceData: interfaceData,
                                passcode: $passcode,
                                value: "\(value)")
                        }
                        PasscodeButton(
                            interfaceData: interfaceData,
                            passcode: $passcode,
                            value: "⌫")
                        PasscodeButton(
                            interfaceData: interfaceData,
                            passcode: $passcode,
                            value: "0")
                        PasscodeButton(
                            interfaceData: interfaceData,
                            passcode: $passcode,
                            value: interfaceData.biometryType)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
            .background(Color.backgroundColor)
            .onAppear {
                interfaceData.getBiometryType()
            }
        }
    }
}

struct LockScreen_Previews: PreviewProvider {
    static var previews: some View {
        LockScreen()
            .environmentObject(InterfaceData(
                dataManager: DataManager(notificationManager: NotificationManager()),
                biometryManager: BiometryManager()))
    }
}

