import Foundation
import CoreGraphics

/// ミラー状態を表すenum
enum MirrorState: String {
    case on = "on"
    case off = "off"
    case none = "none"
}

/// ディスプレイミラー操作を管理するサービス
struct DisplayMirrorService {

    /// 現在のミラー状態を確認
    func queryState() -> MirrorState {
        let displays = getActiveDisplays()
        let mainDisplayID = CGMainDisplayID()

        // 内蔵ディスプレイのみの場合
        if displays.count == 1 {
            return .none
        }

        // 外部ディスプレイが2台以上の場合
        if displays.count > 2 {
            return .none
        }

        // 内蔵 + 外部1台の場合、ミラー状態を確認
        let externalDisplay = displays.first { $0 != mainDisplayID }
        guard let externalDisplayID = externalDisplay else {
            return .none
        }

        return CGDisplayIsInMirrorSet(externalDisplayID) != 0 ? .on : .off
    }

    /// ミラー状態をトグル
    func toggle() throws {
        let currentState = queryState()

        // 条件外の場合は何もしない
        guard currentState != .none else {
            return
        }

        let displays = getActiveDisplays()
        let mainDisplayID = CGMainDisplayID()
        let externalDisplayID = displays.first { $0 != mainDisplayID }!

        var configRef: CGDisplayConfigRef?

        // 設定変更開始
        let beginResult = CGBeginDisplayConfiguration(&configRef)
        guard beginResult == .success, let config = configRef else {
            throw DisplayError.coreGraphicsError("Failed to begin display configuration")
        }

        defer {
            // 設定を確定または破棄
            CGCompleteDisplayConfiguration(config, .permanently)
        }

        let configResult: CGError

        if currentState == .off {
            // 拡張 → ミラー
            configResult = CGConfigureDisplayMirrorOfDisplay(config, externalDisplayID, mainDisplayID)
        } else {
            // ミラー → 拡張（ミラーを解除）
            configResult = CGConfigureDisplayMirrorOfDisplay(config, externalDisplayID, 0)
        }

        guard configResult == .success else {
            throw DisplayError.configurationFailed
        }
    }

    /// アクティブなディスプレイ一覧を取得
    private func getActiveDisplays() -> [CGDirectDisplayID] {
        let maxDisplays: UInt32 = 32
        var displayIDs = Array<CGDirectDisplayID>(repeating: 0, count: Int(maxDisplays))
        var displayCount: UInt32 = 0

        let result = CGGetActiveDisplayList(maxDisplays, &displayIDs, &displayCount)

        guard result == .success else {
            return []
        }

        return Array(displayIDs.prefix(Int(displayCount)))
    }
}
