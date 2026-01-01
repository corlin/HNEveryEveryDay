//
//  SettingsView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("ai_api_key") private var apiKey: String = ""
  @AppStorage("ai_base_url") private var baseURL: String = "https://api.openai.com/v1"
  @AppStorage("ai_model") private var model: String = "gpt-3.5-turbo"

  @Environment(\.dismiss) private var dismiss

  // Provider Preset Logic
  enum AIProvider: String, CaseIterable, Identifiable {
    case openai = "OpenAI"
    case deepseek = "DeepSeek"
    case qwen = "Qwen (Aliyun)"
    case glm = "ChatGLM (Zhipu)"
    case doubao = "Doubao (ByteDance)"
    case gemini = "Gemini (OpenAI Compatibility)"
    case custom = "Custom / Local"

    var id: String { rawValue }

    var defaultBaseURL: String {
      switch self {
      case .openai: return "https://api.openai.com/v1"
      case .deepseek: return "https://api.deepseek.com"
      case .qwen: return "https://dashscope.aliyuncs.com/compatible-mode/v1"
      case .glm: return "https://open.bigmodel.cn/api/paas/v4"
      case .doubao: return "https://ark.cn-beijing.volces.com/api/v3"
      case .gemini: return "https://generativelanguage.googleapis.com/v1beta/openai"
      case .custom: return ""
      }
    }

    var defaultModel: String {
      return suggestedModels.first ?? ""
    }

    var suggestedModels: [String] {
      switch self {
      case .openai: return ["gpt-4o-mini", "gpt-4o", "gpt-3.5-turbo"]
      case .deepseek: return ["deepseek-chat", "deepseek-coder"]
      case .qwen: return ["qwen-turbo", "qwen-plus", "qwen-max"]
      case .glm: return ["glm-4", "glm-4-air", "glm-3-turbo"]
      case .doubao: return []  // Requires ID, no generic name
      case .gemini: return ["gemini-1.5-flash", "gemini-1.5-pro", "gemini-pro"]
      case .custom: return ["llama3", "mistral", "gemma"]
      }
    }
  }

  @State private var selectedProvider: AIProvider = .custom

  var body: some View {
    NavigationStack {
      Form {
        // MARK: - Provider Picker
        Section {
          Picker("Provider Preset", selection: $selectedProvider) {
            ForEach(AIProvider.allCases) { provider in
              Text(provider.rawValue).tag(provider)
            }
          }
          .onChange(of: selectedProvider) { _, newValue in
            if newValue != .custom {
              baseURL = newValue.defaultBaseURL
              model = newValue.defaultModel
            }
          }
        } header: {
          Text("Quick Setup", comment: "Section header")
        }

        // MARK: - Credentials
        Section {
          SecureField("sk-...", text: $apiKey)
        } header: {
          Text("API Key", comment: "Section header")
        } footer: {
          Text("Your key is stored securely on device.", comment: "Security note")
        }

        // MARK: - Advanced Config
        Section("Configuration") {
          TextField("Base URL", text: $baseURL)
            .keyboardType(.URL)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

          VStack(alignment: .leading, spacing: 4) {
            HStack {
              TextField("Model Name", text: $model)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

              // Suggestions Menu
              if !selectedProvider.suggestedModels.isEmpty {
                Menu {
                  ForEach(selectedProvider.suggestedModels, id: \.self) { suggestion in
                    Button(suggestion) {
                      model = suggestion
                    }
                  }
                } label: {
                  Image(systemName: "chevron.up.chevron.down")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
              }
            }

            if selectedProvider == .doubao {
              Text("Note: For Doubao, enter your Endpoint ID (e.g., ep-2024...) here.")
                .font(.caption2)
                .foregroundStyle(.orange)
            }
          }
        }

        if selectedProvider == .custom {
          Section {
            Text(
              "Supports any OpenAI-compatible server (e.g. Ollama, LM Studio). Set Base URL to 'http://localhost:11434/v1' for Ollama."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
          }
        }
      }
      .navigationTitle(Text("AI Settings", comment: "Page title"))
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") {
            dismiss()
          }
        }
      }
    }
    .onAppear {
      // Detect provider from URL
      if let match = AIProvider.allCases.first(where: {
        baseURL.contains($0.defaultBaseURL) && $0 != .custom
      }) {
        selectedProvider = match
      } else {
        selectedProvider = .custom
      }
    }
  }
}

#Preview {
  SettingsView()
}
