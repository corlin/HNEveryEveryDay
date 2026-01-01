//
//  CommentNode.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation

struct CommentNode: Identifiable, Equatable {
  let id: Int
  let item: HNItem
  let depth: Int
  var children: [CommentNode] = []
  var isExpanded: Bool = true

  // Flattened list helper could go here, or in the ViewModel
}
