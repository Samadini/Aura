//
//  ContentView.swift
//  Aura
//
//  Created by STUDENT on 2025-11-21.
//

import SwiftUI

// Enum to manage which screen is currently active
enum AppScreen {
    case splash
    case onboarding
    case home
}

struct ContentView: View {
    // State to track the current screen
    @State private var currentScreen: AppScreen = .splash

    var body: some View {
        ZStack {
            switch currentScreen {
            case .splash:
                AuraSplashView()
            case .onboarding:
                OnboardingView(onGetStarted: {
                    // When the button is tapped, switch to the home screen
                    withAnimation {
                        currentScreen = .home
                    }
                })
            case .home:
                HomeView()
            }
        }
        .onAppear {
            // This block runs when ContentView first appears.
            // We wait for 2.5 seconds, then switch from splash to onboarding.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    currentScreen = .onboarding
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
