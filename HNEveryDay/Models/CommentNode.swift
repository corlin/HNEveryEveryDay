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

  var descendantCount: Int {
    children.reduce(children.count) { count, child in
      count + child.descendantCount
    }
  }

  static func flattened(_ nodes: [CommentNode], collapsedIds: Set<Int> = []) -> [CommentNode] {
    var result: [CommentNode] = []
    for node in nodes {
      result.append(node)
      if !collapsedIds.contains(node.id) && !node.children.isEmpty {
        result.append(contentsOf: flattened(node.children, collapsedIds: collapsedIds))
      }
    }
    return result
  }
}
