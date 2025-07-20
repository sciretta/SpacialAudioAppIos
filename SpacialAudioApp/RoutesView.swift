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

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
            NavigationLink(value: Screens.owner) {
                Text("Go to Owner")
            }
            NavigationLink(value: Screens.guest) {
                Text("Go to Guest")
            }
        }
    }
}

struct RoutesView: View {
    @State private var path: [Screens] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .navigationDestination(for: Screens.self) { screen in
                    switch screen {
                    case .home:
                        HomeView()
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
    RoutesView()
}
