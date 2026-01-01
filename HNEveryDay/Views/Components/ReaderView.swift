//
//  ReaderView.swift
//  HNEveryDay
//
//  Created by AI on 01/01/2026.
//

import SwiftUI
import WebKit

struct ReaderView: UIViewRepresentable {
  let article: ParsedArticle

  // Geeker Style Injection
  private var htmlContent: String {
    return """
      <!DOCTYPE html>
      <html>
      <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
          :root {
              color-scheme: dark;
          }
          body {
              font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
              font-size: 18px;
              line-height: 1.6;
              color: #e0e0e0;
              background-color: #000000;
              padding: 20px 16px;
              margin: 0;
          }
          h1 { font-size: 28px; line-height: 1.3; font-weight: 800; margin-bottom: 8px; color: #ffffff; }
          .byline { font-size: 14px; color: #888; margin-bottom: 24px; font-family: Menlo, monospace; }
          
          p { margin-bottom: 20px; }
          
          img { max-width: 100%; height: auto; border-radius: 8px; margin: 12px 0; }
          figure { margin: 0; }
          figcaption { font-size: 13px; color: #666; text-align: center; margin-top: 4px; }
          
          /* Geeker Code Blocks */
          pre {
              background: #1a1a1a;
              padding: 16px;
              overflow-x: auto;
              border-radius: 8px;
              border: 1px solid #333;
              margin: 20px 0;
          }
          code {
              font-family: "JetBrains Mono", Menlo, "Courier New", monospace;
              font-size: 14px;
              color: #ff9f43; /* Orange-ish for distinction */
          }
          p code {
              background: #222;
              padding: 2px 4px;
              border-radius: 4px;
              color: #ff9f43;
          }
          
          blockquote {
              border-left: 4px solid #ff6600;
              margin: 20px 0;
              padding-left: 16px;
              color: #aaa;
              font-style: italic;
          }
          
          a { color: #ff6600; text-decoration: none; border-bottom: 1px dotted rgba(255, 102, 0, 0.5); }
      </style>
      </head>
      <body>
          <h1>\(article.title ?? "Untitled")</h1>
          <div class="byline">\(article.byline ?? article.siteName ?? "Unknown Source")</div>
          <div class="content">
              \(article.contentHTML ?? "<p>No content extracted.</p>")
          </div>
      </body>
      </html>
      """
  }

  func makeUIView(context: Context) -> WKWebView {
    let config = WKWebViewConfiguration()
    let webView = WKWebView(frame: .zero, configuration: config)
    webView.isOpaque = false
    webView.backgroundColor = .black
    webView.scrollView.indicatorStyle = .white
    return webView
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(htmlContent, baseURL: nil)
  }
}
