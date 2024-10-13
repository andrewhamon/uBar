import AppKit

struct MenuImage: Codable, Hashable {
    var url: String?
    var path: String?
    var systemSymbolName: String?
    var accessibilityDescription: String?
    var width: Double?
    var height: Double?

    func toNSImage(_ imageCache: inout [MenuImage: NSImage]) -> NSImage? {
        if let cachedImage = imageCache[self] {
            return cachedImage
        }

        var image: NSImage? = nil

        if let systemSymbolName {
            if let img = NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: accessibilityDescription) {
                image = img
            }
        }

        if let path {
            if let img = NSImage(contentsOfFile: path) {
                image = img
            }
        }

        if let url {
            if let urlObj = URL(string: url) {
                if let img = NSImage(contentsOf: urlObj) {
                    image = img
                }
            }
        }

        if let height, let img = image, width == nil {
            let originalHeight = img.size.height
            let originalWidth = img.size.width
            let scaleFactor = CGFloat(height) / originalHeight
            let width = originalWidth * scaleFactor
            image?.size = NSSize(width: width, height: height)
        }

        if let width, let img = image, height == nil {
            let originalHeight = img.size.height
            let originalWidth = img.size.width
            let scaleFactor = CGFloat(width) / originalWidth
            let height = originalHeight * scaleFactor
            image?.size = NSSize(width: width, height: height)
        }

        image?.accessibilityDescription = accessibilityDescription
        if let img = image {
            imageCache[self] = img
        }

        return image
    }
}
