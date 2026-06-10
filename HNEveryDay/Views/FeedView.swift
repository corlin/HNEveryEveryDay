//
//  FeedView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

struct FeedView: View {
  @State private var viewModel = FeedViewModel()
  @ObservedObject private var dataService = DataService.shared
  @AppStorage("preferred_language") private var preferredLanguage: String = "system"
  @AppStorage("translation_mode") private var translationModeRaw: String = TranslationMode.off.rawValue
  @State private var showSettings = false
  @State private var showingSavedOnly = false
  @State private var translatedTitles: [Int: String] = [:]
  @State private var translatingTitleIds: Set<Int> = []
  @State private var failedTitleTranslationIds: Set<Int> = []

  private var translationMode: TranslationMode {
    TranslationMode(rawValue: translationModeRaw) ?? .off
  }

  private var targetLanguage: String {
    ReadingLanguage.resolvedCode(preferredLanguage: preferredLanguage)
  }

  var body: some View {
    NavigationStack {
      List {
        // Show saved stories from cache or live feed
        if showingSavedOnly {
          let savedStories = dataService.fetchSavedStories()
          if savedStories.isEmpty {
            ContentUnavailableView(
              "No Saved Stories", systemImage: "bookmark.slash",
              description: Text("Swipe left on a story to save it."))
          } else {
            ForEach(savedStories, id: \.id) { cached in
              let savedItem = item(from: cached)
              NavigationLink(destination: ItemDetailView(item: savedItem)) {
                StoryRowView(
                  item: savedItem,
                  isRead: true,
                  isSaved: true,
                  translatedTitle: translatedTitle(for: savedItem),
                  isTranslatingTitle: translatingTitleIds.contains(savedItem.id)
                )
              }
              .padding(.vertical, 4)
              .task(id: titleTranslationTaskID(for: savedItem)) {
                await translateTitleIfNeeded(for: savedItem)
              }
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  dataService.toggleSave(item: savedItem)
                } label: {
                  Label("Remove", systemImage: "trash")
                }
              }
            }
          }
        } else {
          ForEach(viewModel.stories) { story in
            NavigationLink(destination: ItemDetailView(item: story)) {
              StoryRowView(
                item: story,
                isRead: dataService.readStoryIds.contains(story.id),
                isSaved: dataService.savedStoryIds.contains(story.id),
                translatedTitle: translatedTitle(for: story),
                isTranslatingTitle: translatingTitleIds.contains(story.id)
              )
            }
            .task(id: titleTranslationTaskID(for: story)) {
              await translateTitleIfNeeded(for: story)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button {
                dataService.toggleSave(item: story)
              } label: {
                let isSaved = dataService.savedStoryIds.contains(story.id)
                Label(
                  isSaved ? "Unsave" : "Save", systemImage: isSaved ? "bookmark.slash" : "bookmark")
              }
              .tint(.orange)
            }
            .onAppear {
              if story.id == viewModel.stories.last?.id {
                Task { await viewModel.loadNextPage() }
              }
            }
          }

          if viewModel.isLoading && viewModel.stories.isEmpty {
            SkeletonView()
          }

          if viewModel.stories.isEmpty && !viewModel.isLoading {
            ContentUnavailableView(
              "No Stories Found", systemImage: "wifi.slash",
              description: Text("Check your connection or try again."))
          }
        }
      }
      .listStyle(.plain)
      .navigationTitle(showingSavedOnly ? "Saved" : "Hacker News")
      .refreshable {
        if !showingSavedOnly {
          await viewModel.refresh()
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            showSettings = true
          } label: {
            Image(systemName: "gearshape")
          }
          .accessibilityLabel("Settings")
        }

        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            // Saved Filter Toggle
            Button {
              showingSavedOnly.toggle()
            } label: {
              Label(
                showingSavedOnly ? "Show Feed" : "Saved",
                systemImage: showingSavedOnly ? "list.bullet" : "bookmark.fill")
            }

            Divider()

            Picker(
              "Category",
              selection: Binding(
                get: { viewModel.selectedFeedType },
                set: { type in
                  showingSavedOnly = false
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
            Label(
              "Filter",
              systemImage: showingSavedOnly ? "bookmark.fill" : "line.3.horizontal.decrease.circle")
          }
          .accessibilityLabel("Filter")
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
      // Refresh saved IDs
      dataService.refreshSavedIds()
      // Housekeeping
      dataService.cleanupOldEntries()
    }
  }

  private func item(from cached: CachedStory) -> HNItem {
    HNItem(
      id: cached.id,
      type: .story,
      by: nil,
      time: cached.lastOpened,
      text: nil,
      url: cached.url,
      score: nil,
      title: cached.title,
      descendants: nil,
      kids: nil,
      parent: nil,
      deleted: nil,
      dead: nil
    )
  }

  private func translatedTitle(for item: HNItem) -> String? {
    translatedTitles[item.id]
      ?? DataService.shared.fetchTitleTranslation(id: item.id, targetLanguage: targetLanguage)
  }

  private func titleTranslationTaskID(for item: HNItem) -> String {
    "\(item.id)-\(translationMode.rawValue)-\(targetLanguage)"
  }

  private func translateTitleIfNeeded(for item: HNItem) async {
    guard translationMode == .auto else { return }
    guard let title = item.title, !title.isEmpty else { return }
    guard translatedTitles[item.id] == nil else { return }
    guard !translatingTitleIds.contains(item.id) else { return }
    guard !failedTitleTranslationIds.contains(item.id) else { return }

    if let cached = DataService.shared.fetchTitleTranslation(id: item.id, targetLanguage: targetLanguage) {
      translatedTitles[item.id] = cached
      return
    }

    guard ReadingLanguage.shouldTranslate(sourceText: title, targetLanguage: targetLanguage) else {
      return
    }

    translatingTitleIds.insert(item.id)
    defer { translatingTitleIds.remove(item.id) }

    do {
      let translatedTitle = try await AIService.shared.translateTitle(
        title,
        targetLanguage: targetLanguage
      )
      guard !translatedTitle.isEmpty else { return }
      translatedTitles[item.id] = translatedTitle
      DataService.shared.saveTitleTranslation(
        id: item.id,
        title: title,
        url: item.url,
        targetLanguage: targetLanguage,
        translatedTitle: translatedTitle
      )
    } catch {
      failedTitleTranslationIds.insert(item.id)
    }
  }
}

#Preview {
  FeedView()
}
