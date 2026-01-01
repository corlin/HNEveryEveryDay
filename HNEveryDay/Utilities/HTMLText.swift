//
//  HTMLText.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

enum HTMLHelper {
  /// Strips HTML tags and converts to plain text
  static func stripTags(_ html: String) -> String {
    guard !html.isEmpty else { return "" }

    var result =
      html
      // Convert paragraph and line breaks
      .replacingOccurrences(of: "<p>", with: "")
      .replacingOccurrences(of: "</p>", with: "\n\n")
      .replacingOccurrences(of: "<br>", with: "\n")
      .replacingOccurrences(of: "<br/>", with: "\n")
      .replacingOccurrences(of: "<br />", with: "\n")
      // Decode HTML entities
      .replacingOccurrences(of: "&amp;", with: "&")
      .replacingOccurrences(of: "&lt;", with: "<")
      .replacingOccurrences(of: "&gt;", with: ">")
      .replacingOccurrences(of: "&quot;", with: "\"")
      .replacingOccurrences(of: "&#x27;", with: "'")
      .replacingOccurrences(of: "&#39;", with: "'")
      .replacingOccurrences(of: "&nbsp;", with: " ")
      .replacingOccurrences(of: "&#x2F;", with: "/")

    // Remove remaining HTML tags
    result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)

    // Clean up multiple newlines
    while result.contains("\n\n\n") {
      result = result.replacingOccurrences(of: "\n\n\n", with: "\n\n")
    }

    return result.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// For backward compatibility - parses HTML to AttributedString
  @MainActor
  static func parse(_ html: String) -> AttributedString {
    return AttributedString(stripTags(html))
  }
}
