//
//  CommentNodeTests.swift
//  HNEveryDayTests
//
//  Created by AI on 06/08/2026.
//

import XCTest
@testable import HNEveryDay

final class CommentNodeTests: XCTestCase {
  func testFlattenedPreservesDepthFirstCommentOrder() {
    let nodes = [
      commentNode(
        id: 1,
        children: [
          commentNode(id: 2),
          commentNode(
            id: 3,
            children: [
              commentNode(id: 4)
            ]
          ),
        ]
      ),
      commentNode(id: 5),
    ]

    XCTAssertEqual(CommentNode.flattened(nodes).map(\.id), [1, 2, 3, 4, 5])
  }

  func testFlattenedOmitsCollapsedDescendants() {
    let nodes = [
      commentNode(
        id: 1,
        children: [
          commentNode(id: 2),
          commentNode(
            id: 3,
            children: [
              commentNode(id: 4)
            ]
          ),
        ]
      ),
      commentNode(id: 5),
    ]

    XCTAssertEqual(
      CommentNode.flattened(nodes, collapsedIds: [1]).map(\.id),
      [1, 5]
    )
    XCTAssertEqual(
      CommentNode.flattened(nodes, collapsedIds: [3]).map(\.id),
      [1, 2, 3, 5]
    )
  }

  func testDescendantCountIncludesNestedReplies() {
    let node = commentNode(
      id: 1,
      children: [
        commentNode(id: 2),
        commentNode(
          id: 3,
          children: [
            commentNode(id: 4),
            commentNode(id: 5),
          ]
        ),
      ]
    )

    XCTAssertEqual(node.descendantCount, 4)
  }

  private func commentNode(id: Int, children: [CommentNode] = []) -> CommentNode {
    CommentNode(
      id: id,
      item: HNItem(
        id: id,
        type: .comment,
        by: "user\(id)",
        time: Date(timeIntervalSince1970: Double(id)),
        text: "Comment \(id)",
        url: nil,
        score: nil,
        title: nil,
        descendants: nil,
        kids: nil,
        parent: nil,
        deleted: nil,
        dead: nil
      ),
      depth: 0,
      children: children
    )
  }
}
