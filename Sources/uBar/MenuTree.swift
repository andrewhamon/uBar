struct MenuTree: Codable {
    var id: String?
    var title: String?
    var separator: Bool?
    var indentionLevel: Int?
    var toolTip: String?
    var image: MenuImage?
    var children: [MenuTree]?
}
