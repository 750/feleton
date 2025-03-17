import SwiftUI
import Settings
import Defaults
import KeyboardShortcuts

extension AppSettings.PaneIdentifier {
  static let general = Self("general")
}

/**
Function wrapping SwiftUI into `SettingsPane`, which is mimicking view controller's default construction syntax.
*/
let GeneralSettingsViewController: () -> SettingsPane = {
  /**
  Wrap your custom view into `Settings.Pane`, while providing necessary toolbar info.
  */
  let paneView = AppSettings.Pane(
    identifier: .general,
    title: "General",
    toolbarIcon: NSImage(systemSymbolName: "person.crop.circle", accessibilityDescription: "settings")!
  ) {
    GeneralScreen()
  }

  return Settings.PaneHostingController(pane: paneView)
}

/**
The main view of “Accounts” settings pane.
*/
struct GeneralScreen: View {
  @Default(.url) private var url
  
  func urlIsCorrect() -> Bool {
    if let urlParsed = URL(string: url) {
      return true
    }
    return false
  }
  
  @Default(.title) private var title
  @Default(.sendClipboard) private var sendClipboard
  private let contentWidth: Double = 450.0

  let urlStyle = URL.FormatStyle()

  
  var body: some View {
    Settings.Container(contentWidth: contentWidth) {
      Settings.Section(label: { Text("Toggle", tableName: "GeneralSettings") }) {
        KeyboardShortcuts.Recorder(for: .toggleFeleton)
          .help(Text("OpenTooltip", tableName: "GeneralSettings"))
      }
      
      Settings.Section(label: { Text("Url", tableName: "AppearanceSettings") }) {
          TextField(_: "", text: $url)
          
            .frame(width: 300)
        
        Text(urlIsCorrect() ? "Url seems to be correct": "Bad url", tableName: "AdvancedSettings")
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(urlIsCorrect() ? .green : .red)
            .controlSize(.small)
      }
      
      Settings.Section(title: "") {
        
          Defaults.Toggle("Send clipboard", key: .sendClipboard)
          Text("in query param 'clipboard'", tableName: "AdvancedSettings")
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(.gray)
          
            .controlSize(.small)
        
      }
      
      Settings.Section(label: { Text("Menubar title", tableName: "AppearanceSettings") }) {

            TextField(_: "", text: $title)
              .frame(width: 300)
              .help(Text("PreviewDelayTooltip", tableName: "AppearanceSettings"))
          
          
          
          Text("Single emoji works best", tableName: "AdvancedSettings")
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(.gray)
          
            .controlSize(.small)
      
      }
      
    }
  }
}

struct GeneralScreen_Previews: PreviewProvider {
  static var previews: some View {
    GeneralScreen()
  }
}
