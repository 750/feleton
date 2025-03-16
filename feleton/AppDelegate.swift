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
    panel.toggle();
    let url = urls[0];
  }
  
  @objc func test(_ sender: Any?) {
//    NSApp.activate(ignoringOtherApps: true)
    panel.toggle()
    
  }
  
  func applicationWillFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.accessory)
//    Defaults[.url] = "http://127.0.0.1:9090"

  }
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (event) -> NSEvent in
      if (event.keyCode == 36) {
        self.panel.toggle()
      }
      return event
    }
    
    KeyboardShortcuts.onKeyUp(for: .toggleFeleton) { [self] in
      self.panel.toggle()
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
    button?.title = Defaults[.title]
    button?.action = #selector(test)

    
    panel = FloatingPanel(
      contentRect: NSRect(origin: CGPoint(x: Defaults[.positionX], y: Defaults[.positionY]), size: CGSize(width: Defaults[.width], height: Defaults[.height])),
      identifier: Bundle.main.bundleIdentifier ?? "org.750.feleton",
      statusBarButton: button
    ) {
      ContentView()
    }
    panel.setFrameOrigin(NSPoint(x: Defaults[.positionX], y: Defaults[.positionY]))
  }
}
