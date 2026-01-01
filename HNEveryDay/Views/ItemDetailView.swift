//
//  ItemDetailView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

struct ItemDetailView: View {
  let item: HNItem

  @State private var selectedMode = 0  // 0 = Article, 1 = Comments
  @State private var comments: [CommentNode] = []
  @State private var flattenedComments: [CommentNode] = []
  @State private var isLoadingComments = false
  @State private var showSummary = false
  @State private var collapsedCommentIds: Set<Int> = []

  var body: some View {
    VStack(spacing: 0) {
      // MARK: - Picker
      Picker("Mode", selection: $selectedMode) {
        Text("Article").tag(0)
        Text("Comments").tag(1)
      }
      .pickerStyle(.segmented)
      .padding()
      .background(Color(.systemBackground))
      .zIndex(1)

      // MARK: - Content
      TabView(selection: $selectedMode) {
        // ADDED: Article View
        Group {
          if let url = item.urlObj {
            WebView(url: url)
          } else if item.text != nil {
            ScrollView {
              Text(HTMLHelper.parse(item.text ?? ""))
                .padding()
            }
          } else {
            ContentUnavailableView("No URL", systemImage: "link.badge.plus")
          }
        }
        .tag(0)

        // ADDED: Comments View
        Group {
          if isLoadingComments {
            ProgressView("Loading Thread...")
          } else if flattenedComments.isEmpty {
            ContentUnavailableView("No Comments", systemImage: "bubble.left.and.bubble.right")
          } else {
            List {
              // Header Info
              VStack(alignment: .leading, spacing: 8) {
                Text(item.title ?? "")
                  .font(.headline)
                HStack {
                  Text("\(item.score ?? 0) points")
                  Text("by \(item.by ?? "")")
                  Text(item.time.shortTimeAgo)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
              }
              .listRowSeparator(.hidden)

              ForEach(flattenedComments) { node in
                CommentRowView(node: node, isCollapsed: collapsedCommentIds.contains(node.id))
                  .listRowSeparator(.hidden)
                  .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                  .onTapGesture {
                    toggleCollapse(node.id)
                  }
              }
            }
            .listStyle(.plain)
          }
        }
        .tag(1)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))  // Swipe left/right
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          showSummary = true
        } label: {
          Image(systemName: "sparkles")
        }
      }
    }
    .sheet(isPresented: $showSummary) {
      SummaryView(item: item, comments: comments)
        .presentationDetents([.medium, .large])
    }
    .task {
      await loadComments()
    }
    // Force comments mode if no URL
    .onAppear {
      if item.url == nil {
        selectedMode = 1
      }
    }
  }

  private func toggleCollapse(_ id: Int) {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()

    if collapsedCommentIds.contains(id) {
      collapsedCommentIds.remove(id)
    } else {
      collapsedCommentIds.insert(id)
    }
    // Re-calculate flattened list
    self.flattenedComments = flatten(nodes: comments)
  }

  private func loadComments() async {
    guard let kids = item.kids, !kids.isEmpty else { return }
    guard comments.isEmpty else { return }  // already loaded

    isLoadingComments = true
    do {
      let loader = CommentLoader()
      let rootNodes = try await loader.loadComments(for: kids)
      self.comments = rootNodes
      // Flatten logic
      self.flattenedComments = flatten(nodes: rootNodes)
    } catch {
      print("Failed to load comments: \(error)")
    }
    isLoadingComments = false
  }

  // DFS flattening with Collapse check
  private func flatten(nodes: [CommentNode]) -> [CommentNode] {
    var result: [CommentNode] = []
    for node in nodes {
      result.append(node)
      // If NOT collapsed, include children
      if !collapsedCommentIds.contains(node.id) && !node.children.isEmpty {
        result.append(contentsOf: flatten(nodes: node.children))
      }
    }
    return result
  }
}

#Preview {
  NavigationStack {
    ItemDetailView(
      item: HNItem(
        id: 123,
        type: .story,
        by: "pg",
        time: Date(),
        text: nil,
        url: "https://google.com",
        score: 100,
        title: "Test Story",
        descendants: 5,
        kids: [1],
        parent: nil,
        deleted: nil,
        dead: nil
      ))
  }
}
