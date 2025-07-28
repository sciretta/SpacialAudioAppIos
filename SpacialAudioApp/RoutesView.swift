//
//  RoutesView.swift
//  SpacialAudioApp
//
//  Created by Leonardo on 20/7/25.
//
import SwiftUI

enum Screens: Hashable {
    case home
    case owner
    case guest
}

struct RoutesView: View {
    @State private var path: [Screens] = []
    @EnvironmentObject var appState: AppState

    var body: some View {

        NavigationStack(path: $path) {
            HomeScreenView(path: $path)
                .navigationDestination(for: Screens.self) { screen in

                    switch screen {
                    case .home:
                        HomeScreenView(path: $path)
                    case .owner:
                        OwnerScreenView()
                    case .guest:
                        GuestScreenView()
                    }
                }
        }
    }
}

#Preview {
    RoutesView().environmentObject(AppState())
}
