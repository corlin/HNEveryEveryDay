//
//  CommentRowView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

struct CommentRowView: View {
  let node: CommentNode
  var isCollapsed: Bool = false
  @State private var attributedText: AttributedString?

  // Indentation scaling
  private var indentation: CGFloat {
    return CGFloat(node.depth) * 16.0
  }

  // Color coding for depth lines (optional, kept simple for now)

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      // Header: Author + Time + Collapse State
      HStack {
        Text(node.item.by ?? "unknown")
          .font(.system(size: 13, weight: .bold))
          .foregroundStyle(.primary)

        Text("• \(node.item.time.shortTimeAgo)")
          .font(.caption)
          .foregroundStyle(.secondary)

        if isCollapsed {
          Text("• \(node.children.count) replies hidden")
            .font(.caption)
            .foregroundStyle(.orange)
          Spacer()
          Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundStyle(.secondary)
        } else {
          Spacer()
        }
      }
      .padding(.bottom, 2)

      // Body: Parsed HTML (Hidden if collapsed)
      if !isCollapsed {
        if let text = attributedText {
          Text(text)
            .font(.system(size: 15))
            .foregroundStyle(.primary)
        } else {
          Text("Loading...")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
    .padding(.leading, indentation)  // Visual indentation
    .padding(.vertical, 8)
    .overlay(alignment: .leading) {
      // Optional: Draw a vertical line for depth
      if node.depth > 0 {
        Rectangle()
          .fill(Color.gray.opacity(0.2))
          .frame(width: 2)
          .padding(.leading, indentation - 8)
          .padding(.vertical, 2)
      }
    }
    .contentShape(Rectangle())  // Make tappable area include spacing
    .task {
      if let html = node.item.text {
        // Parse in background to avoid stutter
        let parsed = await Task.detached {
          return HTMLHelper.parse(html)
        }.value
        await MainActor.run {
          self.attributedText = parsed
        }
      } else {
        self.attributedText = AttributedString("[deleted]")
      }
    }
  }
}
