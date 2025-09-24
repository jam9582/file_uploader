import Foundation
import AppKit

@main
struct FolderUploaderApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupUI()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    private func setupUI() {
        // 메인 윈도우 생성
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        window?.title = "폴더 업로더"
        window?.center()

        // 메인 뷰 생성
        let mainView = MainView()
        window?.contentView = mainView
        window?.makeKeyAndOrderFront(nil)
    }
}

class MainView: NSView {
    private var selectedFolderLabel: NSTextField!
    private var fileListScrollView: NSScrollView!
    private var fileListTableView: NSTableView!
    private var selectButton: NSButton!
    private var uploadButton: NSButton!

    private var fileURLs: [URL] = []

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // 폴더 선택 버튼
        selectButton = NSButton(frame: NSRect(x: 20, y: 350, width: 120, height: 30))
        selectButton.title = "폴더 선택"
        selectButton.target = self
        selectButton.action = #selector(selectFolderAction)
        addSubview(selectButton)

        // 선택된 폴더 라벨
        selectedFolderLabel = NSTextField(frame: NSRect(x: 150, y: 355, width: 430, height: 20))
        selectedFolderLabel.isEditable = false
        selectedFolderLabel.isBordered = false
        selectedFolderLabel.backgroundColor = .clear
        selectedFolderLabel.stringValue = "폴더를 선택해주세요"
        addSubview(selectedFolderLabel)

        // 파일 리스트 테이블뷰
        fileListTableView = NSTableView()
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("FileColumn"))
        column.title = "파일 목록"
        column.width = 560
        fileListTableView.addTableColumn(column)
        fileListTableView.dataSource = self
        fileListTableView.delegate = self
        fileListTableView.setDraggingSourceOperationMask(.copy, forLocal: false)
        fileListTableView.allowsMultipleSelection = true

        fileListScrollView = NSScrollView(frame: NSRect(x: 20, y: 80, width: 560, height: 260))
        fileListScrollView.documentView = fileListTableView
        fileListScrollView.hasVerticalScroller = true
        addSubview(fileListScrollView)

        // 드래그 안내 라벨
        let dragLabel = NSTextField(frame: NSRect(x: 20, y: 30, width: 560, height: 30))
        dragLabel.isEditable = false
        dragLabel.isBordered = false
        dragLabel.backgroundColor = .clear
        dragLabel.alignment = .center
        dragLabel.stringValue = "파일 목록에서 드래그해서 업로드하세요"
        dragLabel.textColor = .secondaryLabelColor
        addSubview(dragLabel)
    }

    @objc private func selectFolderAction() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false

        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                self.selectedFolderLabel.stringValue = url.path
                self.scanFolder(url: url)
            }
        }
    }

    private func scanFolder(url: URL) {
        fileURLs.removeAll()
        scanFolderRecursively(url: url)
        fileListTableView.reloadData()

        // 모든 파일을 자동으로 선택
        if !fileURLs.isEmpty {
            let allIndexes = IndexSet(integersIn: 0..<fileURLs.count)
            fileListTableView.selectRowIndexes(allIndexes, byExtendingSelection: false)
        }
    }

    private func scanFolderRecursively(url: URL) {
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            for item in contents {
                let resourceValues = try item.resourceValues(forKeys: [.isDirectoryKey])
                if resourceValues.isDirectory == true {
                    scanFolderRecursively(url: item)
                } else {
                    fileURLs.append(item)
                }
            }
        } catch {
            print("폴더 스캔 오류: \(error)")
        }
    }

}

// MARK: - NSTableViewDataSource
extension MainView: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return fileURLs.count
    }

    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        // 현재 선택된 행들에 해당하는 파일들을 드래그
        let selectedURLs = rowIndexes.compactMap { index in
            index < fileURLs.count ? fileURLs[index] : nil
        }

        // 선택된 파일이 없으면 드래그 안 함
        guard !selectedURLs.isEmpty else { return false }

        pboard.clearContents()

        // 여러 형식으로 데이터 제공 (호환성 향상)
        pboard.writeObjects(selectedURLs as [NSPasteboardWriting])

        // 추가: 파일 경로도 제공
        let filePaths = selectedURLs.map { $0.path }
        pboard.setPropertyList(filePaths, forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType"))

        return true
    }
}

// MARK: - NSTableViewDelegate
extension MainView: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("FileCell")
        var cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView

        if cellView == nil {
            cellView = NSTableCellView()
            cellView?.identifier = identifier

            let textField = NSTextField()
            textField.isEditable = false
            textField.isBordered = false
            textField.backgroundColor = .clear
            cellView?.addSubview(textField)
            cellView?.textField = textField

            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cellView!.leadingAnchor, constant: 5),
                textField.trailingAnchor.constraint(equalTo: cellView!.trailingAnchor, constant: -5),
                textField.centerYAnchor.constraint(equalTo: cellView!.centerYAnchor)
            ])
        }

        cellView?.textField?.stringValue = fileURLs[row].path
        return cellView
    }
}