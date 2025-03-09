//
//  ButtonDetailCapture.swift
//  BugMe
//
//  Created by Abhijith Pm on 9/3/25.
//

import UIKit

class ButtonDetailCapture {
    let button: UIButton
    let controller: String
    
    init(button: UIButton, controller: String) {
        self.button = button
        self.controller = controller
    }
    
    @MainActor
    func getButtonDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Basic properties
        properties.append(BMBlockItemProperties(key: "Title", value: button.title(for: .normal) ?? "nil"))
        properties.append(BMBlockItemProperties(key: "Title (Highlighted)", value: button.title(for: .highlighted) ?? "nil"))
        properties.append(BMBlockItemProperties(key: "Title (Disabled)", value: button.title(for: .disabled) ?? "nil"))
        properties.append(BMBlockItemProperties(key: "Title (Selected)", value: button.title(for: .selected) ?? "nil"))
        properties.append(BMBlockItemProperties(key: "State", value: "\(button.state.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Enabled", value: "\(button.isEnabled)"))
        properties.append(BMBlockItemProperties(key: "Selected", value: "\(button.isSelected)"))
        properties.append(BMBlockItemProperties(key: "Highlighted", value: "\(button.isHighlighted)"))
        
        // Appearance
        properties.append(BMBlockItemProperties(key: "Title Color", value: "\(button.titleColor(for: .normal) ?? .black)"))
        properties.append(BMBlockItemProperties(key: "Title Shadow Color", value: "\(button.titleShadowColor(for: .normal) ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Title Font", value: "\(button.titleLabel?.font ?? UIFont.systemFont(ofSize: 14))"))
        properties.append(BMBlockItemProperties(key: "Content Horizontal Alignment", value: "\(button.contentHorizontalAlignment.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Content Vertical Alignment", value: "\(button.contentVerticalAlignment.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Content Edge Insets", value: "\(button.contentEdgeInsets)"))
        properties.append(BMBlockItemProperties(key: "Title Edge Insets", value: "\(button.titleEdgeInsets)"))
        properties.append(BMBlockItemProperties(key: "Image Edge Insets", value: "\(button.imageEdgeInsets)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(button.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(button.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(button.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(button.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(button.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(button.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(button.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(button.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(button.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(button.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(button.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(button.layer.shadowRadius)"))
        
        // Image handling
        var imagePath: String? = nil
        if let buttonImage = button.currentImage {
            if let imageData = buttonImage.pngData() {
                let fileName = "button_\(controller)_\(button.tag)_image"
                if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent(fileName)
                    .appendingPathExtension("png") {
                    try? imageData.write(to: url)
                    imagePath = url.absoluteString
                }
            }
        }
        
        let title = button.title(for: .normal) ?? "Button \(button.tag)"
        
        return BMBlockItem(
            isView: true,
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
