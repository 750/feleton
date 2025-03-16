//
//  feletonApp.swift
//  feleton
//
//  Created by jarvis-hmac on 16.03.2025.
//

import SwiftUI
import SwiftData

@main
struct feletonApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  
  @State private var hiddenMenu: Bool = false
    var body: some Scene {
      MenuBarExtra("", isInserted: $hiddenMenu) {
        EmptyView()
      }
    }
}
