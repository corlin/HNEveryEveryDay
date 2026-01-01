//
//  HNItem.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation

enum HNItemType: String, Codable {
  case job
  case story
  case comment
  case poll
  case pollopt
}

struct HNItem: Codable, Identifiable, Sendable, Equatable {
  let id: Int
  let type: HNItemType?
  let by: String?
  let time: Date
  let text: String?
  let url: String?
  let score: Int?
  let title: String?
  let descendants: Int?  // Comment count
  let kids: [Int]?  // Comment IDs
  let parent: Int?
  let deleted: Bool?
  let dead: Bool?

  // Helper accessors
  var urlObj: URL? {
    guard let urlString = url else { return nil }
    return URL(string: urlString)
  }
}
