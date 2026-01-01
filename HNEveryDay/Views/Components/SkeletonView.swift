//
//  SkeletonView.swift
//  HNEveryDay
//
//  Created by AI on 02/01/2026.
//

import SwiftUI

struct SkeletonView: View {
  @State private var isAnimating = false

  var body: some View {
    VStack(spacing: 16) {
      ForEach(0..<8, id: \.self) { _ in
        SkeletonRow()
      }
    }
    .padding(.horizontal)
  }
}

struct SkeletonRow: View {
  @State private var shimmerOffset: CGFloat = -1

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      // Score placeholder
      VStack(alignment: .trailing, spacing: 4) {
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.secondary.opacity(0.2))
          .frame(width: 35, height: 16)
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.secondary.opacity(0.15))
          .frame(width: 30, height: 12)
      }
      .frame(width: 45)

      // Content placeholder
      VStack(alignment: .leading, spacing: 8) {
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.secondary.opacity(0.2))
          .frame(height: 16)
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.secondary.opacity(0.15))
          .frame(width: 200, height: 16)
        HStack(spacing: 8) {
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.secondary.opacity(0.1))
            .frame(width: 60, height: 12)
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.secondary.opacity(0.1))
            .frame(width: 80, height: 12)
        }
      }

      Spacer()

      // Comments placeholder
      RoundedRectangle(cornerRadius: 8)
        .fill(Color.secondary.opacity(0.1))
        .frame(width: 44, height: 44)
    }
    .padding(.vertical, 8)
    .overlay(
      GeometryReader { geometry in
        LinearGradient(
          gradient: Gradient(colors: [
            Color.clear,
            Color.white.opacity(0.3),
            Color.clear,
          ]),
          startPoint: .leading,
          endPoint: .trailing
        )
        .frame(width: 100)
        .offset(x: shimmerOffset * geometry.size.width)
        .blendMode(.overlay)
      }
    )
    .clipped()
    .onAppear {
      withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
        shimmerOffset = 2
      }
    }
  }
}

#Preview {
  SkeletonView()
}
