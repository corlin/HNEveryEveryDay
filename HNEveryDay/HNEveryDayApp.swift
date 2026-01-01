//
//  HNEveryDayApp.swift
//  HNEveryDay
//
//  Created by 陈永林 on 01/01/2026.
//

import SwiftData
import SwiftUI

@main
struct HNEveryDayApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(DataService.shared.container)
  }
}
