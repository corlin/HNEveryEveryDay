# HNEveryDay (Geeker Edition)

<p align="center">
  <img src="HNEveryDay/Assets.xcassets/AppIcon.appiconset/HNEveryDay_Icon.png" width="120" alt="HNEveryDay Icon" />
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

---

## 🛠 Tech Stack

- **Language**: Swift 6
- **UI Framework**: SwiftUI (iOS 17+)
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
   git clone https://github.com/corlin/HNEveryEveryDay.git
   ```
2. Open `HNEveryDay.xcodeproj` in Xcode 15+.
3. Build and Run on your iPhone or Simulator.

---

## 🤝 Contribution

PRs are welcome! If you want to add a new AI provider preset or improve the comment rendering engine, feel free to fork.

## 📄 License

MIT License. Hacking is for everyone.
