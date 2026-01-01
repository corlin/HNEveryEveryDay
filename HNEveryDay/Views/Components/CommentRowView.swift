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
  @State private var displayText: String = ""

  // Indentation scaling
  private var indentation: CGFloat {
    return CGFloat(node.depth) * 16.0
  }

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

      // Body: Comment text (Hidden if collapsed)
      if !isCollapsed {
        if !displayText.isEmpty {
          Text(displayText)
            .font(.system(size: 15))
            .foregroundStyle(.primary)
            .textSelection(.enabled)
        } else {
          Text("[no content]")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
    .padding(.leading, indentation)
    .padding(.vertical, 8)
    .overlay(alignment: .leading) {
      if node.depth > 0 {
        Rectangle()
          .fill(Color.gray.opacity(0.2))
          .frame(width: 2)
          .padding(.leading, indentation - 8)
          .padding(.vertical, 2)
      }
    }
    .contentShape(Rectangle())
    .onAppear {
      // Parse HTML on appear (synchronously on main thread)
      if let html = node.item.text, !html.isEmpty {
        displayText = HTMLHelper.stripTags(html)
      } else {
        displayText = "[deleted]"
      }
    }
  }
}
