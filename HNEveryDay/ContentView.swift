//
//  ContentView.swift
//  HNEveryDay
//
//  Created by 陈永林 on 01/01/2026.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false
  
  var body: some View {
    if hasCompletedOnboarding {
      FeedView()
    } else {
      OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
    }
  }
}

#Preview {
  ContentView()
}
