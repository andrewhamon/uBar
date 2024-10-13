import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var imageCache = [MenuImage: NSImage]()
    var statusItem: NSStatusItem?
    var statusBarButton: NSStatusBarButton?

    func applicationDidFinishLaunching(_: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarButton = statusItem?.button

        // Off of the main thread, keep reading JSON from stdin and trying to
        // decode it into a MenuTree. When a MenuTree is successfully decoded,
        // update the menu bar app on the main thread.
        DispatchQueue.global().async {
            while let line = readLine() {
                let data = Data(line.utf8)
                do {
                    let menuTree = try JSONDecoder().decode(MenuTree.self, from: data)
                    DispatchQueue.main.async {
                        self.buildMenuBarApp(menuTree)
                    }
                } catch {
                    fputs("Error decoding JSON: \(error)", stderr)
                }
            }
        }
    }

    private func buildMenuBarApp(_ menuTree: MenuTree) {
        statusBarButton?.title = menuTree.title ?? ""
        statusBarButton?.image = menuTree.image?.toNSImage(&imageCache)
        statusBarButton?.toolTip = menuTree.toolTip
        let main = NSMenu()
        buildMenu(with: menuTree.children ?? [], parentMenu: main)
        statusItem?.menu = main
    }

    private func buildMenu(with items: [MenuTree], parentMenu: NSMenu) {
        for item in items {
            let menuItem = buildMenuItem(item: item)
            parentMenu.addItem(menuItem)
        }
    }

    private func buildMenuItem(item: MenuTree) -> NSMenuItem {
        if item.separator ?? false {
            return NSMenuItem.separator()
        }

        let menuItem = NSMenuItem()

        menuItem.representedObject = item
        menuItem.title = item.title ?? ""
        menuItem.image = item.image?.toNSImage(&imageCache)
        menuItem.toolTip = item.toolTip

        if item.id != nil {
            menuItem.action = #selector(menuItemClicked(_:))
        }

        if let indentionLevel = item.indentionLevel, indentionLevel > 0 {
            menuItem.indentationLevel = indentionLevel
        }

        if let children = item.children {
            let subMenu = NSMenu()
            buildMenu(with: children, parentMenu: subMenu)
            menuItem.submenu = subMenu
        }

        return menuItem
    }

    @objc private func menuItemClicked(_ sender: NSMenuItem) {
        if let id = (sender.representedObject as? MenuTree)?.id {
            let action = MenuAction(id: id, type: "click")
            if let data = try? JSONEncoder().encode(action) {
                print(String(data: data, encoding: .utf8)!)
                fflush(stdout)
            }
        }
    }
}
