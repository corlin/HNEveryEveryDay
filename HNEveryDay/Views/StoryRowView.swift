//
//  StoryRowView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftData
import SwiftUI

struct StoryRowView: View {
  let item: HNItem

  let isRead: Bool

  // No more @Query here. Performance +++.

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      // MARK: - Leading: Logic/Score
      // Using a vertical stack for Score to make it distinct
      VStack(alignment: .trailing, spacing: 2) {
        Text("\(item.score ?? 0)")
          .font(.system(size: 14, weight: .bold, design: .monospaced))
          .foregroundStyle(.orange)

        Text(item.time.shortTimeAgo)
          .font(.system(size: 11, design: .monospaced))
          .foregroundStyle(.secondary)
      }
      .frame(width: 45, alignment: .trailing)
      .padding(.top, 2)

      // MARK: - Center: Content
      VStack(alignment: .leading, spacing: 6) {
        Text(item.title ?? "Untitled")
          .font(.system(size: 16, weight: .medium))
          .foregroundStyle(isRead ? .secondary : .primary)
          .lineLimit(3)
          .fixedSize(horizontal: false, vertical: true)

        HStack(spacing: 6) {
          if let domain = item.url?.hostDomain {
            Text(domain)
              .font(.system(size: 12, weight: .semibold))
              .foregroundStyle(.secondary)
              .padding(.horizontal, 6)
              .padding(.vertical, 2)
              .background(Color.secondary.opacity(0.1))
              .cornerRadius(4)
          }

          Text("by \(item.by ?? "unknown")")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }

      Spacer(minLength: 0)

      // MARK: - Trailing: Comments area
      // Designed as a touch target that is distinct
      VStack(alignment: .center) {
        Image(systemName: "bubble.left.and.bubble.right")
          .font(.system(size: 12))
        Text("\(item.descendants ?? 0)")
          .font(.caption2)
          .fontWeight(.bold)
      }
      .foregroundStyle(.secondary)
      .padding(8)
      .background(Color.secondary.opacity(0.05))
      .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .padding(.vertical, 8)
    .contentShape(Rectangle())  // Make entire row tappable
  }
}

#Preview {
  StoryRowView(
    item: HNItem(
      id: 1,
      type: .story,
      by: "geeker_01",
      time: Date(),
      text: nil,
      url: "https://github.com/apple/swift",
      score: 42,
      title: "Swift 6 Release Notes and Migration Guide for advanced developers",
      descendants: 12,
      kids: [],
      parent: nil,
      deleted: nil,
      dead: nil
    ),
    isRead: false
  )
  .padding()
}
