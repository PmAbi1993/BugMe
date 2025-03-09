//
//  LabelDetailCapture.swift
//  BugMe
//
//  Created by Abhijith Pm on 9/3/25.
//

import UIKit

class LabelDetailCapture {
    let label: UILabel
    let title: String
    
    init(label: UILabel, title: String?) {
        self.label = label
        self.title = title ?? "Unknown Title"
    }
    
    @MainActor
    func getLabelDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Basic properties
        properties.append(BMBlockItemProperties(key: "Text", value: label.text ?? "nil"))
        properties.append(BMBlockItemProperties(key: "Number of Lines", value: "\(label.numberOfLines)"))
        properties.append(BMBlockItemProperties(key: "Text Alignment", value: "\(label.textAlignment.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Line Break Mode", value: "\(label.lineBreakMode.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Adjusts Font Size to Fit Width", value: "\(label.adjustsFontSizeToFitWidth)"))
        properties.append(BMBlockItemProperties(key: "Minimum Scale Factor", value: "\(label.minimumScaleFactor)"))
        properties.append(BMBlockItemProperties(key: "Baseline Adjustment", value: "\(label.baselineAdjustment.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Allows Default Tightening", value: "\(label.allowsDefaultTighteningForTruncation)"))
        
        // Appearance
        properties.append(BMBlockItemProperties(key: "Text Color", value: "\(label.textColor)"))
        properties.append(BMBlockItemProperties(key: "Shadow Color", value: "\(label.shadowColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Shadow Offset", value: "\(label.shadowOffset)"))
        properties.append(BMBlockItemProperties(key: "Highlighted Text Color", value: "\(label.highlightedTextColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Highlighted", value: "\(label.isHighlighted)"))
        properties.append(BMBlockItemProperties(key: "Font", value: "\(label.font)"))
        properties.append(BMBlockItemProperties(key: "Enabled", value: "\(label.isEnabled)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(label.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(label.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(label.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(label.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(label.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(label.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(label.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(label.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(label.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(label.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(label.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(label.layer.shadowRadius)"))
        
        let title = label.text ?? "Label \(label.tag)"
        let imagePath = try? label.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            isView: true,
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
