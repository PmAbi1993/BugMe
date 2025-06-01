import UIKit

class SwitchControlDetailCapture {
    let switchControl: UISwitch
    let title: String
    
    init(switchControl: UISwitch, title: String?) {
        self.switchControl = switchControl
        self.title = title ?? "Unknown Switch"
    }
    
    @MainActor
    func getSwitchDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Switch properties
        properties.append(BMBlockItemProperties(key: "Is On", value: "\(switchControl.isOn)"))
        properties.append(BMBlockItemProperties(key: "On Tint Color", value: "\(switchControl.onTintColor ?? .systemGreen)"))
        properties.append(BMBlockItemProperties(key: "Thumb Tint Color", value: "\(switchControl.thumbTintColor ?? .white)"))
        properties.append(BMBlockItemProperties(key: "Is Enabled", value: "\(switchControl.isEnabled)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(switchControl.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(switchControl.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(switchControl.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(switchControl.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(switchControl.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(switchControl.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(switchControl.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(switchControl.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(switchControl.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(switchControl.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(switchControl.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(switchControl.layer.shadowRadius)"))
        
        let imagePath: String? = try? switchControl.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
