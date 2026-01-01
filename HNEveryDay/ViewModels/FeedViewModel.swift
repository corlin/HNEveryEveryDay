//
//  FeedViewModel.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation
import Observation

@Observable
final class FeedViewModel {
  var stories: [HNItem] = []
  var isLoading = false
  var selectedFeedType: HNClient.StoryType = .top

  // Pagination State
  private var allStoryIds: [Int] = []
  private var currentPage = 0
  private let pageSize = 20
  private var isFetchingPage = false

  var hasMoreStories: Bool {
    return stories.count < allStoryIds.count
  }

  // MARK: - Actions

  @MainActor
  func updateFeedType(_ type: HNClient.StoryType) async {
    guard selectedFeedType != type else { return }
    selectedFeedType = type
    await refresh()
  }

  @MainActor
  func refresh() async {
    guard !isLoading else { return }
    isLoading = true
    stories = []
    allStoryIds = []
    currentPage = 0

    do {
      allStoryIds = try await HNClient.shared.fetchStoryIds(type: selectedFeedType)
      await loadNextPage()
    } catch {
      print("Failed to fetch IDs: \(error)")
    }

    isLoading = false
  }

  @MainActor
  func loadNextPage() async {
    guard !isFetchingPage && hasMoreStories else { return }
    isFetchingPage = true

    let startIndex = currentPage * pageSize
    let endIndex = min(startIndex + pageSize, allStoryIds.count)

    guard startIndex < endIndex else {
      isFetchingPage = false
      return
    }

    let pageIds = Array(allStoryIds[startIndex..<endIndex])

    do {
      let newStories = try await HNClient.shared.fetchItems(ids: pageIds)
      // Filter out any failed fetches (nils are already handled in client, but verify non-nil content)
      // Also filter out dead/deleted if they came through
      let validStories = newStories.filter { $0.title != nil }

      self.stories.append(contentsOf: validStories)
      self.currentPage += 1
    } catch {
      print("Failed to load page: \(error)")
    }

    isFetchingPage = false
  }
}
