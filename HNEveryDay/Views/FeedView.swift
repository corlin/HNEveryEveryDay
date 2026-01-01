//
//  FeedView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

struct FeedView: View {
  @State private var viewModel = FeedViewModel()
  @State private var showSettings = false

  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.stories) { story in
          NavigationLink(destination: ItemDetailView(item: story)) {
            StoryRowView(item: story)
          }
          .onAppear {
            if story.id == viewModel.stories.last?.id {
              Task { await viewModel.loadNextPage() }
            }
          }
        }

        if viewModel.isLoading && viewModel.stories.isEmpty {
          ContentUnavailableView {
            ProgressView()
          } description: {
            Text("Loading Stories...")
          }
        }

        if viewModel.stories.isEmpty && !viewModel.isLoading {
          ContentUnavailableView("No Stories Found", systemImage: "wifi.slash")
        }
      }
      .listStyle(.plain)
      .navigationTitle("Hacker News")
      .refreshable {
        await viewModel.refresh()
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            showSettings = true
          } label: {
            Image(systemName: "gearshape")
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Picker(
              "Category",
              selection: Binding(
                get: { viewModel.selectedFeedType },
                set: { type in
                  Task { await viewModel.updateFeedType(type) }
                }
              )
            ) {
              Label("Top", systemImage: "flame").tag(HNClient.StoryType.top)
              Label("New", systemImage: "clock").tag(HNClient.StoryType.new)
              Label("Best", systemImage: "star").tag(HNClient.StoryType.best)
              Label("Show", systemImage: "eye").tag(HNClient.StoryType.show)
              Label("Ask", systemImage: "questionmark.circle").tag(HNClient.StoryType.ask)
              Label("Jobs", systemImage: "briefcase").tag(HNClient.StoryType.job)
            }
          } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
          }
        }
      }
      .sheet(isPresented: $showSettings) {
        SettingsView()
      }
    }
    .task {
      // Initial load
      if viewModel.stories.isEmpty {
        await viewModel.refresh()
      }
    }
  }
}

#Preview {
  FeedView()
}
