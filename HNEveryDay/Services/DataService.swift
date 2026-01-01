//
//  DataService.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Combine
import Foundation
import SwiftData

@MainActor
class DataService: ObservableObject {
  static let shared = DataService()

  let container: ModelContainer

  @Published var readStoryIds: Set<Int> = []

  init() {
    do {
      let schema = Schema([CachedStory.self])
      let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
      self.container = try ModelContainer(for: schema, configurations: [modelConfiguration])
      // Initial fetch of read IDs
      self.refreshReadIds()
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }

  func refreshReadIds() {
    let context = container.mainContext
    // Fetch only IDs of read stories for performance
    // Note: SwiftData currently doesn't support fetching strictly IDs easily with Predicate alone without loading models,
    // but we can fetch models with a lightweight descriptor.
    // Optimization: We could use a specific Model for just ID/isRead if needed, but for now fetching CachedStory is okay as long as we don't load Content.
    // Actually, let's just fetch all where isRead == true.
    let descriptor = FetchDescriptor<CachedStory>(predicate: #Predicate { $0.isRead })
    do {
      let stories = try context.fetch(descriptor)
      self.readStoryIds = Set(stories.map { $0.id })
    } catch {
      print("Failed to fetch read IDs: \(error)")
    }
  }

  func cleanupOldEntries(days: Int = 30) {
    Task {  // Run on background
      let context = ModelContext(container)
      let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()

      let descriptor = FetchDescriptor<CachedStory>(
        predicate: #Predicate {
          $0.lastOpened < cutoffDate && !$0.isSaved
        })

      do {
        let oldStories = try context.fetch(descriptor)
        if !oldStories.isEmpty {
          print("🧹 Housekeeping: Deleting \(oldStories.count) old stories.")
          for story in oldStories {
            context.delete(story)
          }
          try context.save()
        }
      } catch {
        print("Housekeeping failed: \(error)")
      }
    }
  }

  func markAsRead(item: HNItem) {
    let context = container.mainContext
    let id = item.id

    let descriptor = FetchDescriptor<CachedStory>(predicate: #Predicate { $0.id == id })

    do {
      let results = try context.fetch(descriptor)
      if let existing = results.first {
        existing.isRead = true
        existing.lastOpened = Date()
      } else {
        let newStory = CachedStory(
          id: item.id,
          title: item.title ?? "Untitled",
          url: item.url,
          isRead: true,
          lastOpened: Date()
        )
        context.insert(newStory)
      }
      try context.save()

      // Update local set
      self.readStoryIds.insert(id)
    } catch {
      print("Failed to mark as read: \(error)")
    }
  }

  func saveContent(id: Int, content: String) {
    let context = container.mainContext
    let descriptor = FetchDescriptor<CachedStory>(predicate: #Predicate { $0.id == id })
    do {
      if let existing = try context.fetch(descriptor).first {
        existing.contentHTML = content
        try context.save()
      }
    } catch {
      print("Failed to save content: \(error)")
    }
  }

  func saveSummary(id: Int, summary: String) {
    let context = container.mainContext
    let descriptor = FetchDescriptor<CachedStory>(predicate: #Predicate { $0.id == id })
    do {
      if let existing = try context.fetch(descriptor).first {
        existing.summary = summary
        try context.save()
      }
    } catch {
      print("Failed to save summary: \(error)")
    }
  }
}
