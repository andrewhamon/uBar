import AppKit

struct MenuImage: Codable, Hashable {
    let url: String?
    let path: String?
    let systemSymbolName: String?
    let accessibilityDescription: String?
    let width: Double?
    let height: Double?

    func toNSImage(_ imageCache: inout [MenuImage: NSImage]) -> NSImage? {
        if let image = imageCache[self] {
            return image
        }

        var image: NSImage? = nil

        if let systemSymbolName {
            image = NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: accessibilityDescription)
        }

        if let path {
            image = NSImage(contentsOfFile: path)
        }

        if let url {
            if let urlObj = URL(string: url) {
                image = NSImage(contentsOf: urlObj)
            }
        }

        var possibleScaleFactors: [Double] = []

        if let newHeight = height, let image, newHeight > 0 {
            let originalHeight = image.size.height
            let scaleFactor = newHeight / originalHeight

            possibleScaleFactors.append(scaleFactor)
        }

        if let newWidth = width, let image, newWidth > 0 {
            let originalWidth = image.size.width
            let scaleFactor = newWidth / originalWidth

            possibleScaleFactors.append(scaleFactor)
        }

        if let scaleFactor = possibleScaleFactors.min(), let image {
            image.size = NSSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
        }

        image?.accessibilityDescription = accessibilityDescription

        if let image {
            imageCache[self] = image
        }

        return image
    }
}
