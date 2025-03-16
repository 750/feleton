import Defaults
import Foundation

extension Defaults.Keys {
  static let url = Key<String>("url", default: "http://example.com")
  static let title = Key<String>("title", default: "🚦")
  
  static let positionX = Key<CGFloat>("positionX", default: 0)
  static let positionY = Key<CGFloat>("positionY", default: 0)
  static let width = Key<CGFloat>("width", default: 500)
  static let height = Key<CGFloat>("height", default: 500)
}
