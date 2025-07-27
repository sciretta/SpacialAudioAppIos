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

    var body: some View {
        NavigationStack(path: $path) {
            HomeScreenView()
                .navigationDestination(for: Screens.self) { screen in
                    switch screen {
                    case .home:
                        HomeScreenView()
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
