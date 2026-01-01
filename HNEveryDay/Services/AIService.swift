//
//  AIService.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import Foundation
import SwiftUI

final class AIService: Sendable {
  static let shared = AIService()

  // User Configuration
  // In a real app, use Keychain. For now, AppStorage/UserDefaults via a helper.
  @AppStorage("ai_api_key") private var userApiKey: String = ""
  @AppStorage("ai_base_url") private var userBaseURL: String = "https://api.openai.com/v1"
  @AppStorage("ai_model") private var userModel: String = "gpt-3.5-turbo"

  // Request Models
  struct ChatMessage: Codable {
    let role: String
    let content: String
  }

  struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double
  }

  struct ChatResponse: Codable {
    struct Choice: Codable {
      let message: ChatMessage
    }
    let choices: [Choice]
  }

  // Core Logic
  func summarize(title: String, url: String?, comments: [String]) async throws -> String {
    let apiKey = UserDefaults.standard.string(forKey: "ai_api_key") ?? ""
    let baseUrl = UserDefaults.standard.string(forKey: "ai_base_url") ?? "https://api.openai.com/v1"
    let model = UserDefaults.standard.string(forKey: "ai_model") ?? "gpt-3.5-turbo"

    guard !apiKey.isEmpty else {
      throw NSError(
        domain: "AIService", code: 401,
        userInfo: [
          NSLocalizedDescriptionKey: "API Key is missing. Please configure it in Settings."
        ])
    }

    // Construct Prompt
    var prompt = "You are a tech-savvy summarizer for Hacker News users. \n"
    prompt += "Story Title: \(title)\n"
    if let url = url {
      prompt += "URL: \(url)\n"
    }
    prompt += "\nTop Comments:\n"
    for comment in comments.prefix(20) {  // Limit to top 20 comments to fit context window
      // Strip excessive newlines and HTML tags roughly
      let cleanComment = comment.replacingOccurrences(
        of: "<[^>]+>", with: "", options: .regularExpression)
      prompt += "- \(cleanComment.prefix(300))...\n"  // Truncate individual comments
    }

    prompt +=
      "\nTask: Please provide a concise summary of the discussion. Highlight the main points of the article (if inferred) and, more importantly, the key insights, debates, or critiques from the comments. Keep it under 200 words. Format in Markdown."

    // Build Request
    let requestBody = ChatRequest(
      model: model,
      messages: [
        ChatMessage(role: "system", content: "You are a helpful assistant."),
        ChatMessage(role: "user", content: prompt),
      ],
      temperature: 0.7
    )

    let endpoint =
      URL(string: baseUrl)?.appendingPathComponent("chat/completions") ?? URL(
        string: "https://api.openai.com/v1/chat/completions")!

    var request = URLRequest(url: endpoint)
    request.httpMethod = "POST"
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(requestBody)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown Error"
      throw NSError(
        domain: "AIService", code: (response as? HTTPURLResponse)?.statusCode ?? 500,
        userInfo: [NSLocalizedDescriptionKey: "API Request Failed: \(errorMsg)"])
    }

    let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
    return chatResponse.choices.first?.message.content ?? "No response content."
  }
}
