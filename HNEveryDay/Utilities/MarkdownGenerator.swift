//
//  MarkdownGenerator.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation

struct MarkdownGenerator {
  static func generate(
    item: HNItem,
    summary: String?,
    article: ParsedArticle?,
    comments: [CommentNode]
  ) -> String {
    let date = Date().formatted(date: .numeric, time: .omitted)
    let hnLink = "https://news.ycombinator.com/item?id=\(item.id)"

    var md = """
      ---
      tags: #hackernews #link
      date: \(date)
      source: \(hnLink)
      ---
      # \(item.title ?? "Untitled")

      """

    if let url = item.url {
      md += "\n**Original Link**: [\(item.urlObj?.host ?? "Link")](\(url))\n"
    }

    // AI Summary
    if let summary = summary, !summary.isEmpty {
      md += """

        ## 🤖 AI Summary
        \(summary)

        """
    }

    // Key Insights (Top Comments)
    // Simple logic: Take top 5 top-level comments for now
    let topComments = comments.prefix(5)
    if !topComments.isEmpty {
      md += "\n## 💬 Key Discussion\n"

      for node in topComments {
        let author = node.item.by ?? "user"
        // Strip HTML tags for cleaner Markdown (simple regex)
        let text =
          node.item.text?.replacingOccurrences(
            of: "<[^>]+>", with: "", options: .regularExpression, range: nil
          )
          .replacingOccurrences(of: "&#x27;", with: "'")
          .replacingOccurrences(of: "&quot;", with: "\"") ?? ""

        md += "- **@\(author)**: \(text)\n"
      }
    }

    // Article Content (Smart Reader)
    if let article = article, let content = article.textContent {
      md += """

        ## 📄 Article Content
        > *Extracted by HNEveryDay Smart Reader*

        \(content)
        """
    }

    return md
  }
}
