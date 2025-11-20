import Foundation

/// ディスプレイ操作に関するエラー定義
enum DisplayError: Error, LocalizedError {
    case coreGraphicsError(String)
    case configurationFailed
    case unsupportedConfiguration

    var errorDescription: String? {
        switch self {
        case .coreGraphicsError(let message):
            return "CoreGraphics Error: \(message)"
        case .configurationFailed:
            return "Display configuration failed"
        case .unsupportedConfiguration:
            return "Unsupported display configuration"
        }
    }
}
