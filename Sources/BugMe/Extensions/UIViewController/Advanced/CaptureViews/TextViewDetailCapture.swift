import UIKit

class TextViewDetailCapture {
    let textView: UITextView
    let title: String
    
    init(textView: UITextView, title: String?) {
        self.textView = textView
        self.title = title ?? "Unknown TextView"
    }
    
    @MainActor
    func getTextViewDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Text properties
        properties.append(BMBlockItemProperties(key: "Text", value: textView.text))
        properties.append(BMBlockItemProperties(key: "Text Color", value: "\(textView.textColor ?? .black)"))
        properties.append(BMBlockItemProperties(key: "Font", value: "\(textView.font ?? UIFont.systemFont(ofSize: 14))"))
        properties.append(BMBlockItemProperties(key: "Text Alignment", value: "\(textView.textAlignment.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Selected Range", value: "\(textView.selectedRange)"))
        
        // Input properties
        properties.append(BMBlockItemProperties(key: "Is Editable", value: "\(textView.isEditable)"))
        properties.append(BMBlockItemProperties(key: "Is Selectable", value: "\(textView.isSelectable)"))
        properties.append(BMBlockItemProperties(key: "Keyboard Type", value: "\(textView.keyboardType.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Return Key Type", value: "\(textView.returnKeyType.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Secure Text Entry", value: "\(textView.isSecureTextEntry)"))
        properties.append(BMBlockItemProperties(key: "Auto-correction", value: "\(textView.autocorrectionType.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Auto-capitalization", value: "\(textView.autocapitalizationType.rawValue)"))
        
        // Scroll properties
        properties.append(BMBlockItemProperties(key: "Content Size", value: "\(textView.contentSize)"))
        properties.append(BMBlockItemProperties(key: "Content Offset", value: "\(textView.contentOffset)"))
        properties.append(BMBlockItemProperties(key: "Content Inset", value: "\(textView.contentInset)"))
        properties.append(BMBlockItemProperties(key: "Shows Vertical Scroll Indicator", value: "\(textView.showsVerticalScrollIndicator)"))
        properties.append(BMBlockItemProperties(key: "Shows Horizontal Scroll Indicator", value: "\(textView.showsHorizontalScrollIndicator)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(textView.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(textView.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(textView.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(textView.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(textView.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(textView.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(textView.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(textView.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(textView.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(textView.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(textView.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(textView.layer.shadowRadius)"))
        
        let imagePath: String? = try? textView.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
