//
//  HNClient.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation

enum HNClientError: Error {
  case invalidURL
  case networkError(Error)
  case decodingError(Error)
  case unknown
}

final class HNClient: Sendable {
  static let shared = HNClient()
  private let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0")!

  private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
  }()

  // MARK: - Core Fetching

  func fetchItem(id: Int) async throws -> HNItem {
    let url = baseURL.appendingPathComponent("item/\(id).json")
    return try await fetch(url: url)
  }

  func fetchUser(id: String) async throws -> HNUser {
    let url = baseURL.appendingPathComponent("user/\(id).json")
    return try await fetch(url: url)
  }

  // MARK: - Story Lists

  enum StoryType: String {
    case top = "topstories"
    case new = "newstories"
    case best = "beststories"
    case ask = "askstories"
    case show = "showstories"
    case job = "jobstories"
  }

  func fetchStoryIds(type: StoryType) async throws -> [Int] {
    let url = baseURL.appendingPathComponent("\(type.rawValue).json")
    return try await fetch(url: url)
  }

  // MARK: - Batch Helper

  /// Fetches all items in parallel using TaskGroup
  func fetchItems(ids: [Int]) async throws -> [HNItem] {
    return try await withThrowingTaskGroup(of: HNItem?.self) { group in
      for id in ids {
        group.addTask {
          try? await self.fetchItem(id: id)
        }
      }

      var items: [HNItem] = []
      for try await item in group {
        if let item = item {
          items.append(item)
        }
      }

      // Re-sort results to match the order of input ids
      // Note: This optimization is debatable for large lists, but fine for a page.
      // If performance matters more, we can skip sorting here and sort in UI.
      // But let's keep it robust for the caller.
      let itemMap = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
      return ids.compactMap { itemMap[$0] }
    }
  }

  // MARK: - Internal

  private func fetch<T: Decodable>(url: URL) async throws -> T {
    let (data, _) = try await URLSession.shared.data(from: url)
    do {
      return try jsonDecoder.decode(T.self, from: data)
    } catch {
      throw HNClientError.decodingError(error)
    }
  }
}
