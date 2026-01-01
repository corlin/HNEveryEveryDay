//
//  HNUser.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation

struct HNUser: Codable, Identifiable, Sendable {
  let id: String  // The user's unique username. Case-sensitive.
  let created: Date
  let karma: Int
  let about: String?
  let submitted: [Int]?
}
