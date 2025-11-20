import Foundation

/// メイン処理
func main() {
    let service = DisplayMirrorService()
    let arguments = CommandLine.arguments

    // 引数解析
    if arguments.contains("--query") || arguments.contains("-q") {
        // 状態確認モード
        let state = service.queryState()
        print(state.rawValue)
        exit(0)
    }

    // トグルモード
    do {
        try service.toggle()
        exit(0)
    } catch {
        fputs("Error: \(error.localizedDescription)\n", stderr)
        exit(1)
    }
}

// メイン処理実行
main()
