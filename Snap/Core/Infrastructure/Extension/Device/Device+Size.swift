import UIKit

extension Device {
  public var size: CGSize {
    switch self {
    case .iPhone5: return CGSize(width: 320, height: 568)
    case .iPhone8: return CGSize(width: 375, height: 667)
    case .iPhone8Plus: return CGSize(width: 414, height: 736)
    case .iPhoneX: return CGSize(width: 375, height: 812)
    case .iPhoneXSMax: return CGSize(width: 414, height: 896)
    case .iPadMini: return CGSize(width: 768, height: 1024)
    case .iPadAir: return CGSize(width: 768, height: 1024)
    case .iPadAirLandscape: return CGSize(width: 1024, height: 768)
    case .iPadPro105: return CGSize(width: 834, height: 1112)
    case .iPadPro105Landscape: return CGSize(width: 1112, height: 834)
    case .iPadPro129: return CGSize(width: 1024, height: 1366)
    }
  }
}
