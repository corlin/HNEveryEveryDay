//
//  String+Extensions.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation

extension String {
  /// Extracts the host domain from a URL string (e.g., "github.com").
  var hostDomain: String? {
    guard let url = URL(string: self),
      let host = url.host()
    else {
      return nil
    }

    // Strip 'www.' if present
    if host.hasPrefix("www.") {
      return String(host.dropFirst(4))
    }
    return host
  }
}
