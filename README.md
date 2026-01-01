# HNEveryDay (Geeker Edition)

<p align="center">
  <img src="HNEveryDay/Assets.xcassets/AppIcon.appiconset/HNEveryDay_Icon.png" width="120" alt="HNEveryDay Icon" />
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README_ZH.md">简体中文</a>
</p>

**HNEveryDay** is a high-performance, privacy-first, AI-enhanced Hacker News client for iOS, built specifically for Geekers who live in the terminal and dream in code.

It combines the raw information density favored by hackers with the fluid, tactile experience of a modern native iOS app.

## ✨ Features

### 🚀 Extreme Performance
- **120fps Scrolling**: Built with optimized SwiftUI lists to handle thousands of items without dropping a frame.
- **Parallel Fetching**: Custom networking layer fetches story metadata and comments in concurrent batches for instant loading.

### 💬 Deep Discussion threads
- **Recursive Threading**: Visualizes the deep nesting of HN comments with clear, color-coded indentation.
- **Collapsible Threads**: **Tap any comment** to fold its entire subtree. Cleaning up the noise to find the signal has never been easier.
- **Rich Text Rendering**: Full support for HN's HTML comments (italics, code blocks, links) rendered natively.

### 🤖 Local-First AI Intelligence
Get the "Hacker Perspective" in seconds.
- **Magic Summary**: Tap the ✨ button to generate a concise summary of the **Article + Top Discussion**. We don't just summarize the link; we summarize *what hackers are saying about it*.
- **BYO Key (Bring Your Own Key)**: No subscriptions. Use your own API Key.
- **Multi-Provider Support**: Built-in presets for the best Global and Chinese models:
    - 🇨🇳 **DeepSeek** (Recommended for coding/tech context)
    - 🇨🇳 **Qwen (Tongyi Qianwen)**
    - 🇨🇳 **ChatGLM (Zhipu)**
    - 🇨🇳 **Doubao (ByteDance)**
    - 🇺🇸 **Gemini** (via OpenAI Compatibility)
    - 🇺🇸 **OpenAI** (GPT-4o/mini)
    - 🏠 **Localhost** (Ollama/LM Studio support)

### 🎨 Interaction Polish
- **Hybrid Detail View**: Swipe between the Web Article and the Comment Thread seamlessly.
- **Haptic Feedback**: Tactile confirmation for collapsing threads and AI completion.
- **Pure Dark Mode**: Designed for OLED displays.

### 📖 Native Smart Reader (v0.02)
- **Distraction Free**: Removes ads, popups, and clutter. Just the text.
- **Geeker Styled**: Dark mode verified; Code blocks rendered with monospaced fonts and horizontal scrolling.
- **Offline Ready**: Automatically caches article content for subway reading.

### 🧠 Knowledge Engine (v0.02)
- **Markdown Export**: Share -> "Square & Arrow" -> Generates a formatted research note.
- **Deep Context**: Export includes Metadata, AI Summary, and Key Comments. Perfect for Obsidian/Notion.
- **Read History**: Automatically tracks what you've read (Gray links).

### 🌏 Globalization (v0.03)
- **Chinese Support**: Full UI localization for Simplified Chinese (简体中文).
- **Contextual AI**: The AI automatically detects your language and summarizes English articles *in Chinese* if your system language is set to Chinese.

### 🛡️ Robustness (v0.03)
- **Smart Retries**: AI Service includes exponential backoff retry logic (3x) to handle unstable networks.
- **Fail Gracefully**: Improved error UI guides you to fix API keys or network issues.

### ⚙️ Unified Settings (v0.04)
- **One-Stop Config**: AI Provider, Language Preference, and Cache Retention all in one place.
- **Onboarding**: First-launch welcome screen highlighting key features.

### 🔖 Complete & Polish (v0.05)
- **Bookmarks**: Swipe left to save stories for later. Filter by "Saved" in the menu.
- **Keychain Security**: API keys are now stored in iOS Keychain (not UserDefaults).
- **Skeleton Loading**: Shimmer animation while the feed loads for a premium feel.

---

## 🛠 Tech Stack

- **Language**: Swift 6
- **UI Framework**: SwiftUI (iOS 17+)
- **Persistence**: **SwiftData** with optimized "Read-Through" caching.
- **Concurrency**: Swift 6 `async/await`, `Actors` for thread-safe data fetching.
- **State Management**: MVVM + Observation Framework (`@Observable`).
- **Networking**: Custom `URLSession` wrapper interacting with Hacker News Firebase API.

---

## ⚙️ Configuration

### Setting up AI
1. Tap the **Gear Icon** (⚙️) on the main feed.
2. Select your **Provider Preset** (e.g., DeepSeek).
    - *The App automatically fills the correct Base URL and Model Name.*
3. Paste your **API Key**.
4. (Optional) You can manually edit the Model Name to use specific versions (e.g., `deepseek-coder`).
5. Tap **Done**. Keys are stored securely on-device using `AppStorage`.

---

## 📥 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/corlin/HNEveryDay.git
   ```
2. Open `HNEveryDay.xcodeproj` in Xcode 15+.
3. Build and Run on your iPhone or Simulator.

---

## 🤝 Contribution

PRs are welcome! If you want to add a new AI provider preset or improve the comment rendering engine, feel free to fork.

## 📄 License

MIT License. Hacking is for everyone.
