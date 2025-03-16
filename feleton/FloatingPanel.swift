import SwiftUI
import Cocoa
import Defaults
// An NSPanel subclass that implements floating panel traits.
// https://stackoverflow.com/questions/46023769/how-to-show-a-window-without-stealing-focus-on-macos
class FloatingPanel<Content: View>: NSPanel, NSWindowDelegate {
  var isPresented: Bool = false
  var statusBarButton: NSStatusBarButton?

  func windowDidMove(_ notification: Notification) {
    Defaults[.positionX] = self.frame.origin.x
    Defaults[.positionY] = self.frame.origin.y
    
    print(Defaults[.positionX])
    print(Defaults[.positionY])
  }
  
  func windowDidResize(_ notification: Notification) {
    Defaults[.width] = self.frame.width
    Defaults[.height] = self.frame.height
  }
  
  init(
    contentRect: NSRect,
    identifier: String = "",
    statusBarButton: NSStatusBarButton? = nil,
    view: () -> Content
  ) {
    super.init(
        contentRect: contentRect,
        styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView],
        backing: .buffered,
        defer: false
    )

    self.statusBarButton = statusBarButton
    self.identifier = NSUserInterfaceItemIdentifier(identifier)

    delegate = self

    animationBehavior = .none
    isFloatingPanel = true
    level = .statusBar
    collectionBehavior = [.auxiliary, .stationary, .moveToActiveSpace, .fullScreenAuxiliary]
    titleVisibility = .hidden
    titlebarAppearsTransparent = true
    isMovableByWindowBackground = true
    hidesOnDeactivate = false

    // Hide all traffic light buttons
    standardWindowButton(.closeButton)?.isHidden = true
    standardWindowButton(.miniaturizeButton)?.isHidden = true
    standardWindowButton(.zoomButton)?.isHidden = true

    contentView = NSHostingView(
      rootView: view()
        // The safe area is ignored because the title bar still interferes with the geometry
        .ignoresSafeArea()
        .gesture(DragGesture()
          .onEnded { _ in
        })
    )
  }

  func toggle() {
    if isPresented {
      close()
    } else {
      open()
    }
  }

  func open() {
    setContentSize(NSSize(width: frame.width, height: frame.height))
    orderFrontRegardless()
    makeKey()
    isPresented = true
    DispatchQueue.main.async {
      self.statusBarButton?.isHighlighted = true
    }

  }
  

  // Close automatically when out of focus, e.g. outside click.
  override func resignKey() {
    print("resigning now")
    super.resignKey()
    close()
  }

  override func close() {
    super.close()
    isPresented = false
    statusBarButton?.isHighlighted = false
  }

  // Allow text inputs inside the panel can receive focus
  override var canBecomeKey: Bool {
    return true
  }
}
