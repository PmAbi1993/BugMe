import UIKit

class TextFieldDetailCapture {
    let textField: UITextField
    let title: String
    
    init(textField: UITextField, title: String?) {
        self.textField = textField
        self.title = title ?? "Unknown TextField"
    }
    
    @MainActor
    func getTextFieldDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Text properties
        properties.append(BMBlockItemProperties(key: "Text", value: textField.text ?? "nil"))
        properties.append(BMBlockItemProperties(key: "Placeholder", value: textField.placeholder ?? "nil"))
        properties.append(BMBlockItemProperties(key: "Text Color", value: "\(textField.textColor ?? .black)"))
        properties.append(BMBlockItemProperties(key: "Font", value: "\(textField.font ?? UIFont.systemFont(ofSize: 14))"))
        properties.append(BMBlockItemProperties(key: "Text Alignment", value: "\(textField.textAlignment.rawValue)"))
        
        // Input properties
        properties.append(BMBlockItemProperties(key: "Is Editing", value: "\(textField.isEditing)"))
        properties.append(BMBlockItemProperties(key: "Keyboard Type", value: "\(textField.keyboardType.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Return Key Type", value: "\(textField.returnKeyType.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Secure Text Entry", value: "\(textField.isSecureTextEntry)"))
        properties.append(BMBlockItemProperties(key: "Auto-correction", value: "\(textField.autocorrectionType.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Auto-capitalization", value: "\(textField.autocapitalizationType.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Enabled", value: "\(textField.isEnabled)"))
        
        // Appearance
        properties.append(BMBlockItemProperties(key: "Border Style", value: "\(textField.borderStyle.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Clear Button Mode", value: "\(textField.clearButtonMode.rawValue)"))
        if let leftView = textField.leftView {
            properties.append(BMBlockItemProperties(key: "Left View Mode", value: "\(textField.leftViewMode.rawValue)"))
            properties.append(BMBlockItemProperties(key: "Left View Class", value: "\(type(of: leftView))"))
        }
        if let rightView = textField.rightView {
            properties.append(BMBlockItemProperties(key: "Right View Mode", value: "\(textField.rightViewMode.rawValue)"))
            properties.append(BMBlockItemProperties(key: "Right View Class", value: "\(type(of: rightView))"))
        }
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(textField.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(textField.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(textField.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(textField.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(textField.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(textField.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(textField.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(textField.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(textField.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(textField.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(textField.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(textField.layer.shadowRadius)"))
        
        let imagePath: String? = try? textField.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
