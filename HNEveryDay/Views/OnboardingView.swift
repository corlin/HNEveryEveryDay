//
//  OnboardingView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

struct OnboardingView: View {
  @Binding var hasCompletedOnboarding: Bool

  var body: some View {
    VStack(spacing: 0) {
      Spacer()

      // MARK: - Logo & Title
      VStack(spacing: 16) {
        Image(systemName: "y.square.fill")
          .font(.system(size: 80))
          .foregroundStyle(.orange)

        Text("HNEveryDay", comment: "App name")
          .font(.system(size: 32, weight: .bold, design: .rounded))

        Text("Geeker Edition", comment: "App subtitle")
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
      .padding(.bottom, 48)

      // MARK: - Features
      VStack(alignment: .leading, spacing: 24) {
        FeatureRow(
          icon: "bolt.fill",
          color: .yellow,
          title: String(localized: "120fps Feed", comment: "Feature title"),
          description: String(
            localized: "Buttery smooth scrolling optimized for speed.", comment: "Feature desc")
        )

        FeatureRow(
          icon: "doc.plaintext.fill",
          color: .blue,
          title: String(localized: "Smart Reader", comment: "Feature title"),
          description: String(
            localized: "Ad-free, distraction-free article parsing.", comment: "Feature desc")
        )

        FeatureRow(
          icon: "sparkles",
          color: .purple,
          title: String(localized: "AI Summaries", comment: "Feature title"),
          description: String(
            localized: "Get the gist of article + discussion in seconds.", comment: "Feature desc")
        )

        FeatureRow(
          icon: "arrow.down.doc.fill",
          color: .green,
          title: String(localized: "Knowledge Export", comment: "Feature title"),
          description: String(
            localized: "One-tap Markdown export for Obsidian/Notion.", comment: "Feature desc")
        )
      }
      .padding(.horizontal, 32)

      Spacer()

      // MARK: - Get Started
      Button {
        withAnimation {
          hasCompletedOnboarding = true
        }
      } label: {
        Text("Get Started", comment: "Button")
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding()
          .background(.orange)
          .foregroundStyle(.white)
          .clipShape(RoundedRectangle(cornerRadius: 14))
      }
      .padding(.horizontal, 32)
      .padding(.bottom, 48)
    }
    .background(Color(.systemBackground))
  }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
  let icon: String
  let color: Color
  let title: String
  let description: String

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundStyle(color)
        .frame(width: 32)

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.headline)
        Text(description)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
}

#Preview {
  OnboardingView(hasCompletedOnboarding: .constant(false))
}
