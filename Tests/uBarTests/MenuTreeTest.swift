import XCTest

@testable import uBar

class uBarTests: XCTestCase {
    func testStructsInitialize() {
        let data = """
        {
            "id": "1",
            "title": "Title",
            "separator": true,
            "indentionLevel": 1,
            "toolTip": "Tooltip",
            "image": {
                "url": "imageUrl",
            },
            "children": [
                {
                    "id": "2",
                    "title": "Title2",
                    "separator": true,
                    "indentionLevel": 2,
                    "toolTip": "Tooltip2",
                    "children": []
                }
            ]
        }
        """.data(using: .utf8)!

        let menuTree = try! JSONDecoder().decode(MenuTree.self, from: data)

        XCTAssertEqual(menuTree.id, "1")
        XCTAssertEqual(menuTree.title, "Title")
        XCTAssertEqual(menuTree.separator, true)
        XCTAssertEqual(menuTree.indentionLevel, 1)
        XCTAssertEqual(menuTree.toolTip, "Tooltip")
        XCTAssertEqual(menuTree.image?.url, "imageUrl")
        XCTAssertEqual(menuTree.children?.count, 1)
    }
}
