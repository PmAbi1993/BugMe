import UIKit

class ImageViewDetailCapture {
    let imageView: UIImageView
    let title: String
    
    init(imageView: UIImageView, title: String?) {
        self.imageView = imageView
        self.title = title ?? "Unknown ImageView"
    }
    
    @MainActor
    func getImageViewDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Image properties
        properties.append(BMBlockItemProperties(key: "Has Image", value: "\(imageView.image != nil)"))
        properties.append(BMBlockItemProperties(key: "Content Mode", value: "\(imageView.contentMode.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Tint Color", value: "\(imageView.tintColor ?? .black)"))
        properties.append(BMBlockItemProperties(key: "Highlighted", value: "\(imageView.isHighlighted)"))
        if let highlightedImage = imageView.highlightedImage {
            properties.append(BMBlockItemProperties(key: "Has Highlighted Image", value: "\(highlightedImage)"))
        }
        properties.append(BMBlockItemProperties(key: "Animating", value: "\(imageView.isAnimating)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(imageView.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(imageView.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(imageView.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(imageView.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(imageView.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(imageView.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(imageView.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(imageView.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(imageView.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(imageView.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(imageView.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(imageView.layer.shadowRadius)"))
        
        let imagePath: String? = try? imageView.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
