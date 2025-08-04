//
//  EnterSessionCode.component.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 27/7/25.
//
import SwiftUI

public struct EnterSessionCode: View {
    @State private var sessionCode: String = ""
    @EnvironmentObject var appState: AppState
    public var body: some View {
        TextField("Enter code", text: $sessionCode)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: sessionCode) { oldValue, newValue in
                if newValue.count >= 8 {
                    appState.sessionCode = newValue
                }
            }
    }
}

#Preview {
    EnterSessionCode().environmentObject(AppState())
}
