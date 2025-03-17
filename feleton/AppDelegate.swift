//
//  AppDelegate.swift
//  feleton
//
//  Created by jarvis-hmac on 16.03.2025.
//

import Foundation
import SwiftUI
import Defaults
import KeyboardShortcuts
import Settings


class AppDelegate: NSObject, NSApplicationDelegate {
  @Default(.title) var title
  
  let contentView = ContentView()
  
  private var settingsWindowController = SettingsWindowController(
    panes: [
      GeneralSettingsViewController(),
    ],
    style: .segmentedControl
  )
  @IBAction
  func settingsMenuItemActionHandler(_ sender: NSMenuItem) {
    settingsWindowController.show()
  }
  
  var panel: FloatingPanel<ContentView>!
  var statusBarItem: NSStatusItem!
  
  func application(_ application: NSApplication, open urls: [URL]) {
    if (panel.toggle()) {
      contentView.reload()
    }
//    let url = urls[0];
  }
  
  @objc func toggle(_ sender: Any?) {
    if (panel.toggle()) {
      contentView.reload()
    }
   
  }
  
  func applicationWillFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.accessory)
    
//    NSApp.activate(ignoringOtherApps: true)
    //    Defaults[.url] = "http://127.0.0.1:9090"

  }
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (event) -> NSEvent in
//      if (event.keyCode == 36) {
//        self.panel.toggle()
//      }
      return event
    }
    
    KeyboardShortcuts.onKeyUp(for: .toggleFeleton) { [self] in
      self.toggle(nil)
    }
    
    NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (event) -> NSEvent in
//      print(event.keyCode)
      if (event.keyCode == 43 && (event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command)) {
        self.settingsWindowController.show()
        self.settingsWindowController.window?.orderFrontRegardless()
      }
      return event
    }
    
    if let window = NSApplication.shared.windows.first {
        window.close()
    }
    
    let statusBar = NSStatusBar.system
    statusBarItem = statusBar.statusItem(withLength: 16)

    let button = statusBarItem.button
    button?.action = #selector(toggle)
    
    
    panel = FloatingPanel(
      contentRect: NSRect(origin: CGPoint(x: Defaults[.positionX], y: Defaults[.positionY]), size: CGSize(width: Defaults[.width], height: Defaults[.height])),
      identifier: Bundle.main.bundleIdentifier ?? "org.750.feleton",
      statusBarButton: button
    ) {
      contentView
    }
    
    
    Task {
      for await value in Defaults.updates(.title) {
        panel.statusBarButton!.title = value
      }
    }
    panel.setFrameOrigin(NSPoint(x: Defaults[.positionX], y: Defaults[.positionY]))
  }
}
