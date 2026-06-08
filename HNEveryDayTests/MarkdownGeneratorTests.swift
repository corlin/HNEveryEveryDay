//
//  MarkdownGeneratorTests.swift
//  HNEveryDayTests
//
//  Created by AI on 08/06/2026.
//

import XCTest
@testable import HNEveryDay

final class MarkdownGeneratorTests: XCTestCase {
  func testGenerateIncludesStoryMetadataSummaryCommentsAndArticle() {
    let story = HNItem(
      id: 42,
      type: .story,
      by: "pg",
      time: Date(timeIntervalSince1970: 1_735_689_600),
      text: nil,
      url: "https://example.com/post",
      score: 100,
      title: "A Useful HN Story",
      descendants: 2,
      kids: [1001],
      parent: nil,
      deleted: nil,
      dead: nil
    )
    let comment = HNItem(
      id: 1001,
      type: .comment,
      by: "hn_user",
      time: Date(timeIntervalSince1970: 1_735_689_700),
      text: "<p>This is &quot;excellent&quot; and useful.</p>",
      url: nil,
      score: nil,
      title: nil,
      descendants: nil,
      kids: nil,
      parent: 42,
      deleted: nil,
      dead: nil
    )
    let article = ParsedArticle(
      title: "Article Title",
      byline: "Author",
      contentHTML: "<p>Full article</p>",
      textContent: "Full article text",
      excerpt: nil,
      siteName: "Example"
    )

    let markdown = MarkdownGenerator.generate(
      item: story,
      summary: "Concise summary.",
      article: article,
      comments: [CommentNode(id: comment.id, item: comment, depth: 0)]
    )

    XCTAssertTrue(markdown.contains("# A Useful HN Story"))
    XCTAssertTrue(markdown.contains("https://news.ycombinator.com/item?id=42"))
    XCTAssertTrue(markdown.contains("**Original Link**: [example.com](https://example.com/post)"))
    XCTAssertTrue(markdown.contains("## 🤖 AI Summary"))
    XCTAssertTrue(markdown.contains("Concise summary."))
    XCTAssertTrue(markdown.contains("## 💬 Key Discussion"))
    XCTAssertTrue(markdown.contains("**@hn_user**"))
    XCTAssertTrue(markdown.contains("This is \"excellent\" and useful."))
    XCTAssertTrue(markdown.contains("## 📄 Article Content"))
    XCTAssertTrue(markdown.contains("Full article text"))
  }

  func testGenerateOmitsEmptySummarySection() {
    let story = HNItem(
      id: 7,
      type: .story,
      by: nil,
      time: Date(),
      text: nil,
      url: nil,
      score: nil,
      title: "No Summary",
      descendants: nil,
      kids: nil,
      parent: nil,
      deleted: nil,
      dead: nil
    )

    let markdown = MarkdownGenerator.generate(
      item: story,
      summary: "",
      article: nil,
      comments: []
    )

    XCTAssertFalse(markdown.contains("## 🤖 AI Summary"))
    XCTAssertTrue(markdown.contains("# No Summary"))
  }
}
