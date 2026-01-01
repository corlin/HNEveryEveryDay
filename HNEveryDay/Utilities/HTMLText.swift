//
//  HTMLText.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

enum HTMLHelper {
  nonisolated static func parse(_ html: String) -> AttributedString {
    guard let data = html.data(using: .utf8) else {
      return AttributedString(html)
    }

    do {
      let nsAttrString = try NSAttributedString(
        data: data,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue,
        ],
        documentAttributes: nil
      )
      return AttributedString(nsAttrString)
    } catch {
      return AttributedString(html)
    }
  }
}
