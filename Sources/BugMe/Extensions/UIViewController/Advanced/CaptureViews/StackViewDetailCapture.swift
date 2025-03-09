import UIKit

class StackViewDetailCapture {
    let stackView: UIStackView
    let title: String
    
    init(stackView: UIStackView, title: String?) {
        self.stackView = stackView
        self.title = title ?? "Unknown StackView"
    }
    
    @MainActor
    func getStackViewDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Stack properties
        properties.append(BMBlockItemProperties(key: "Axis", value: "\(stackView.axis.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Distribution", value: "\(stackView.distribution.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Alignment", value: "\(stackView.alignment.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Spacing", value: "\(stackView.spacing)"))
        properties.append(BMBlockItemProperties(key: "Arranged Subviews Count", value: "\(stackView.arrangedSubviews.count)"))
        properties.append(BMBlockItemProperties(key: "Is Base Line Relative Arrangement", value: "\(stackView.isBaselineRelativeArrangement)"))
        properties.append(BMBlockItemProperties(key: "Is Layout Margins Relative Arrangement", value: "\(stackView.isLayoutMarginsRelativeArrangement)"))
        
        // Layout properties
        properties.append(BMBlockItemProperties(key: "Layout Margins", value: "\(stackView.layoutMargins)"))
        properties.append(BMBlockItemProperties(key: "Directional Layout Margins", value: "\(stackView.directionalLayoutMargins)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(stackView.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(stackView.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(stackView.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(stackView.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(stackView.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(stackView.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(stackView.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(stackView.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(stackView.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(stackView.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(stackView.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(stackView.layer.shadowRadius)"))
        
        let imagePath: String? = try? stackView.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
