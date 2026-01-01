//
//  SummaryView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

struct SummaryView: View {
  let item: HNItem
  let comments: [CommentNode]
  let article: ParsedArticle?
  var onSummaryGenerated: ((String) -> Void)?

  @State private var summaryText: String = ""
  @State private var isLoading = true
  @State private var errorMsg: String?

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          if isLoading {
            VStack(spacing: 12) {
              ProgressView()
                .controlSize(.large)
              Text("Analyzing discussion...")
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 200)
          } else if let error = errorMsg {
            VStack(spacing: 12) {
              Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
              Text(error)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            }
            .padding()
          } else {
            // Success State
            Text(try! AttributedString(markdown: summaryText))  // Basic Markdown parsing
              .font(.system(size: 16, design: .serif))
              .lineSpacing(6)
          }
        }
        .padding()
      }
      .navigationTitle("Magic Summary")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          if !isLoading {
            ShareLink(item: summaryText)
          }
        }
      }
    }
    .task {
      await generateSummary()
    }
  }

  private func generateSummary() async {
    // Collect comment texts
    // Flatten first level only for now, or traverse a bit?
    // AIService prompt only takes list of strings.
    var commentTexts: [String] = []
    for node in comments {
      if let text = node.item.text {
        commentTexts.append(text)
      }
    }

    do {
      let result = try await AIService.shared.summarize(
        title: item.title ?? "Unknown",
        url: item.url,
        articleContent: article?.textContent,
        comments: commentTexts
      )
      await MainActor.run {
        self.summaryText = result
        self.isLoading = false
        self.onSummaryGenerated?(result)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
      }
    } catch {
      await MainActor.run {
        self.errorMsg = error.localizedDescription
        self.isLoading = false
      }
    }
  }
}
