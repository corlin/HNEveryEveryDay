//
//  Date+Extensions.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation

extension Date {
  /// Returns a short relative time string (e.g., "5m", "2h", "1d").
  var shortTimeAgo: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated
    return formatter.localizedString(for: self, relativeTo: Date())
  }
}
