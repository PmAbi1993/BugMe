import UIKit

class ViewDetailCapture {
    let view: UIView
    let title: String
    
    init(view: UIView, title: String?) {
        self.view = view
        self.title = title ?? "Unknown View"
    }
    
    @MainActor
    func getViewDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Layout properties
        properties.append(BMBlockItemProperties(key: "Content Mode", value: "\(view.contentMode.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Layout Margins", value: "\(view.layoutMargins)"))
        properties.append(BMBlockItemProperties(key: "Directional Layout Margins", value: "\(view.directionalLayoutMargins)"))
        properties.append(BMBlockItemProperties(key: "Preserves Superview Layout Margins", value: "\(view.preservesSuperviewLayoutMargins)"))
        properties.append(BMBlockItemProperties(key: "Is Layout Margins Relative Arrangement", value: "\(view.insetsLayoutMarginsFromSafeArea)"))
        
        // Appearance properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(view.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(view.alpha)"))
        properties.append(BMBlockItemProperties(key: "Is Opaque", value: "\(view.isOpaque)"))
        properties.append(BMBlockItemProperties(key: "Tint Color", value: "\(view.tintColor ?? .systemBlue)"))
        properties.append(BMBlockItemProperties(key: "Tint Adjustment Mode", value: "\(view.tintAdjustmentMode.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Clip To Bounds", value: "\(view.clipsToBounds)"))
        properties.append(BMBlockItemProperties(key: "Mask To Bounds", value: "\(view.layer.masksToBounds)"))
        
        // Interaction properties
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(view.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(view.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Multiple Touch Enabled", value: "\(view.isMultipleTouchEnabled)"))
        properties.append(BMBlockItemProperties(key: "Exclusive Touch", value: "\(view.isExclusiveTouch)"))
        
        // Geometry properties
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(view.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(view.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(view.bounds)"))
        properties.append(BMBlockItemProperties(key: "Center", value: "\(view.center)"))
        properties.append(BMBlockItemProperties(key: "Transform", value: "\(view.transform)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(view.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(view.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(view.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Color", value: "\(view.layer.shadowColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(view.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(view.layer.shadowRadius)"))
        properties.append(BMBlockItemProperties(key: "Shadow Offset", value: "\(view.layer.shadowOffset)"))
        
        let imagePath: String? = try? view.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
