struct MenuTree: Codable, Hashable {
    let id: String?
    let title: String?
    let separator: Bool?
    let indentionLevel: Int?
    let toolTip: String?
    let image: MenuImage?
    let children: [MenuTree]?
}
