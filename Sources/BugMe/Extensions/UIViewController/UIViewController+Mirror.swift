//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import UIKit
import OSLog

struct BMElementProperties {
    let propertyName: String
    let propertyValue: String
}

struct BMElementInformation {
    let image: UIImage?
    let elementName: String
    let elementType: String
    let properties: [BMElementProperties]
    
    // Helper method to format the properties for logging
    func formattedDescription() -> String {
        var result = "Captured \(elementType): \(elementName)\n"
        result += "-- Properties --\n"
        
        for property in properties {
            result += "  - \(property.propertyName): \(property.propertyValue)\n"
        }
        
        return result.trimmingCharacters(in: .newlines)
    }
}

struct BMElementBlock {
    let controller: String
    let elements: [BMElementInformation]
}

public extension UIViewController {
    var controllerName: String { String(describing: type(of: self)) }
    
    func capture() {
        let controllerName = self.controllerName
        
        // Clear any previous captures for this controller
        BMElementManager.shared.clearElements(forController: controllerName)
        
        // Capture all elements
        for child in Mirror(reflecting: self).children {
            switch child.value {
            case let button as UIButton:
                captureButton(button, label: child.label)

            case let label as UILabel:
                captureLabel(label, name: child.label)

            case let imageView as UIImageView:
                captureImageView(imageView, name: child.label)

            case let textField as UITextField:
                captureTextField(textField, name: child.label)

            case let textView as UITextView:
                captureTextView(textView, name: child.label)

            case let tableView as UITableView:
                captureTableView(tableView, name: child.label)

            case let collectionView as UICollectionView:
                captureCollectionView(collectionView, name: child.label)

            case let stackView as UIStackView:
                captureStackView(stackView, name: child.label)

            case let switchControl as UISwitch:
                captureSwitch(switchControl, name: child.label)

            case let scrollView as UIScrollView:
                captureScrollView(scrollView, name: child.label)

            case let view as UIView:
                captureView(view, name: child.label)

            case let viewController as UIViewController:
                captureViewController(viewController, name: child.label)

            default:
                captureUnhandledType(child.value, label: child.label)
            }
        }
        
        // Log the element block once all elements are captured
        BMElementManager.shared.logElementBlock(forController: controllerName)
    }
    
    // MARK: - UI Element Capture Methods
    
    private func captureButton(_ button: UIButton, label: String?) {
        let elementName = label ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Title", propertyValue: button.title(for: .normal) ?? "nil"))
        properties.append(BMElementProperties(propertyName: "State", propertyValue: "\(button.state.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Enabled", propertyValue: "\(button.isEnabled)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(button.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(button.frame)"))
        properties.append(BMElementProperties(propertyName: "Tag", propertyValue: "\(button.tag)"))
        
        var image: UIImage? = nil
        if let buttonImage = button.currentImage {
            image = buttonImage
            if let imageData = buttonImage.pngData() {
                let path = try? saveToDocuments(data: imageData, fileName: "button_\(elementName)_image", fileExtension: "png")
                properties.append(BMElementProperties(propertyName: "Image Path", propertyValue: path?.absoluteString ?? "nil"))
            }
        }
        
        let elementInfo = BMElementInformation(
            image: image,
            elementName: elementName,
            elementType: "UIButton",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureLabel(_ label: UILabel, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Text", propertyValue: label.text ?? "nil"))
        properties.append(BMElementProperties(propertyName: "Text Color", propertyValue: "\(label.textColor)"))
        properties.append(BMElementProperties(propertyName: "Font", propertyValue: "\(label.font)"))
        properties.append(BMElementProperties(propertyName: "Lines", propertyValue: "\(label.numberOfLines)"))
        properties.append(BMElementProperties(propertyName: "Alignment", propertyValue: "\(label.textAlignment.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(label.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(label.frame)"))
        
        let elementInfo = BMElementInformation(
            image: label.takeScreenshot(),
            elementName: elementName,
            elementType: "UILabel",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureImageView(_ imageView: UIImageView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Content Mode", propertyValue: "\(imageView.contentMode.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Has Image", propertyValue: "\(imageView.image != nil)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(imageView.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(imageView.frame)"))
        
        var image: UIImage? = nil
        if let viewImage = imageView.image {
            image = viewImage
            if let imageData = viewImage.pngData() {
                let path = try? saveToDocuments(data: imageData, fileName: "imageView_\(elementName)_image", fileExtension: "png")
                properties.append(BMElementProperties(propertyName: "Image Path", propertyValue: path?.absoluteString ?? "nil"))
            }
        }
        
        let elementInfo = BMElementInformation(
            image: image,
            elementName: elementName,
            elementType: "UIImageView",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureTextField(_ textField: UITextField, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Text", propertyValue: textField.text ?? "nil"))
        properties.append(BMElementProperties(propertyName: "Placeholder", propertyValue: textField.placeholder ?? "nil"))
        properties.append(BMElementProperties(propertyName: "Text Color", propertyValue: "\(textField.textColor ?? .black)"))
        properties.append(BMElementProperties(propertyName: "Font", propertyValue: "\(textField.font ?? UIFont.systemFont(ofSize: 14))"))
        properties.append(BMElementProperties(propertyName: "Alignment", propertyValue: "\(textField.textAlignment.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Is Editing", propertyValue: "\(textField.isEditing)"))
        properties.append(BMElementProperties(propertyName: "Is Secure", propertyValue: "\(textField.isSecureTextEntry)"))
        properties.append(BMElementProperties(propertyName: "Keyboard Type", propertyValue: "\(textField.keyboardType.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(textField.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(textField.frame)"))
        
        let elementInfo = BMElementInformation(
            image: textField.takeScreenshot(),
            elementName: elementName,
            elementType: "UITextField",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureTextView(_ textView: UITextView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Text", propertyValue: textView.text))
        properties.append(BMElementProperties(propertyName: "Text Color", propertyValue: "\(textView.textColor ?? .black)"))
        properties.append(BMElementProperties(propertyName: "Font", propertyValue: "\(textView.font ?? UIFont.systemFont(ofSize: 14))"))
        properties.append(BMElementProperties(propertyName: "Editable", propertyValue: "\(textView.isEditable)"))
        properties.append(BMElementProperties(propertyName: "Selectable", propertyValue: "\(textView.isSelectable)"))
        properties.append(BMElementProperties(propertyName: "Alignment", propertyValue: "\(textView.textAlignment.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(textView.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(textView.frame)"))
        
        let elementInfo = BMElementInformation(
            image: textView.takeScreenshot(),
            elementName: elementName,
            elementType: "UITextView",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureTableView(_ tableView: UITableView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Number of Sections", propertyValue: "\(tableView.numberOfSections)"))
        properties.append(BMElementProperties(propertyName: "Style", propertyValue: "\(tableView.style.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Separator Style", propertyValue: "\(tableView.separatorStyle.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Row Height", propertyValue: "\(tableView.rowHeight)"))
        properties.append(BMElementProperties(propertyName: "Allows Selection", propertyValue: "\(tableView.allowsSelection)"))
        properties.append(BMElementProperties(propertyName: "Allows Multiple Selection", propertyValue: "\(tableView.allowsMultipleSelection)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(tableView.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(tableView.frame)"))
        
        let screenShot = tableView.captureTableViewScreenshots()
        let combinedImage = screenShot.combineImagesVertically()
        
        if let pngData = combinedImage.pngData() {
            let path = try? saveToDocuments(data: pngData, fileName: "tableView_\(elementName)", fileExtension: "jpg")
            properties.append(BMElementProperties(propertyName: "Screenshot Path", propertyValue: path?.absoluteString ?? "nil"))
        }
        
        let elementInfo = BMElementInformation(
            image: combinedImage,
            elementName: elementName,
            elementType: "UITableView",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureCollectionView(_ collectionView: UICollectionView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Number of Sections", propertyValue: "\(collectionView.numberOfSections)"))
        properties.append(BMElementProperties(propertyName: "Allows Selection", propertyValue: "\(collectionView.allowsSelection)"))
        properties.append(BMElementProperties(propertyName: "Allows Multiple Selection", propertyValue: "\(collectionView.allowsMultipleSelection)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(collectionView.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(collectionView.frame)"))
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            properties.append(BMElementProperties(propertyName: "Item Size", propertyValue: "\(layout.itemSize)"))
            properties.append(BMElementProperties(propertyName: "Scroll Direction", propertyValue: layout.scrollDirection == .vertical ? "Vertical" : "Horizontal"))
        }
        
        let elementInfo = BMElementInformation(
            image: collectionView.screenshotEntireContent(),
            elementName: elementName,
            elementType: "UICollectionView",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureStackView(_ stackView: UIStackView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Axis", propertyValue: stackView.axis == .horizontal ? "Horizontal" : "Vertical"))
        properties.append(BMElementProperties(propertyName: "Alignment", propertyValue: "\(stackView.alignment.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Distribution", propertyValue: "\(stackView.distribution.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Spacing", propertyValue: "\(stackView.spacing)"))
        properties.append(BMElementProperties(propertyName: "Arranged Subviews Count", propertyValue: "\(stackView.arrangedSubviews.count)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(stackView.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(stackView.frame)"))
        
        let elementInfo = BMElementInformation(
            image: stackView.takeScreenshot(),
            elementName: elementName,
            elementType: "UIStackView",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureSwitch(_ switchControl: UISwitch, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Is On", propertyValue: "\(switchControl.isOn)"))
        properties.append(BMElementProperties(propertyName: "Enabled", propertyValue: "\(switchControl.isEnabled)"))
        properties.append(BMElementProperties(propertyName: "On Tint Color", propertyValue: "\(switchControl.onTintColor ?? .systemBlue)"))
        properties.append(BMElementProperties(propertyName: "Thumb Tint Color", propertyValue: "\(switchControl.thumbTintColor ?? .white)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(switchControl.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(switchControl.frame)"))
        
        let elementInfo = BMElementInformation(
            image: switchControl.takeScreenshot(),
            elementName: elementName,
            elementType: "UISwitch",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureScrollView(_ scrollView: UIScrollView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Content Size", propertyValue: "\(scrollView.contentSize)"))
        properties.append(BMElementProperties(propertyName: "Content Offset", propertyValue: "\(scrollView.contentOffset)"))
        properties.append(BMElementProperties(propertyName: "Content Inset", propertyValue: "\(scrollView.contentInset)"))
        properties.append(BMElementProperties(propertyName: "Bounces", propertyValue: "\(scrollView.bounces)"))
        properties.append(BMElementProperties(propertyName: "Paging Enabled", propertyValue: "\(scrollView.isPagingEnabled)"))
        properties.append(BMElementProperties(propertyName: "Shows Indicators", propertyValue: "H:\(scrollView.showsHorizontalScrollIndicator) V:\(scrollView.showsVerticalScrollIndicator)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(scrollView.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(scrollView.frame)"))
        // TODO: Create scrolled complete image
        let elementInfo = BMElementInformation(
            image: scrollView.captureEntireScrollView(),
            elementName: elementName,
            elementType: "UIScrollView",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureView(_ view: UIView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Background Color", propertyValue: "\(view.backgroundColor ?? .clear)"))
        properties.append(BMElementProperties(propertyName: "Alpha", propertyValue: "\(view.alpha)"))
        properties.append(BMElementProperties(propertyName: "Is User Interaction Enabled", propertyValue: "\(view.isUserInteractionEnabled)"))
        properties.append(BMElementProperties(propertyName: "Tag", propertyValue: "\(view.tag)"))
        properties.append(BMElementProperties(propertyName: "Hidden", propertyValue: "\(view.isHidden)"))
        properties.append(BMElementProperties(propertyName: "Frame", propertyValue: "\(view.frame)"))
        properties.append(BMElementProperties(propertyName: "Subviews Count", propertyValue: "\(view.subviews.count)"))
        properties.append(BMElementProperties(propertyName: "Layer Properties", propertyValue: "Corner Radius: \(view.layer.cornerRadius), Border Width: \(view.layer.borderWidth)"))
        
        let elementInfo = BMElementInformation(
            image: view.takeScreenshot(),
            elementName: elementName,
            elementType: "UIView",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureViewController(_ viewController: UIViewController, name: String?) {
        let elementName = name ?? "No label found"
        var properties = [BMElementProperties]()
        
        properties.append(BMElementProperties(propertyName: "Title", propertyValue: viewController.title ?? "nil"))
        properties.append(BMElementProperties(propertyName: "View Loaded", propertyValue: "\(viewController.isViewLoaded)"))
        properties.append(BMElementProperties(propertyName: "Presentation Style", propertyValue: "\(viewController.modalPresentationStyle.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Transition Style", propertyValue: "\(viewController.modalTransitionStyle.rawValue)"))
        properties.append(BMElementProperties(propertyName: "Child VCs Count", propertyValue: "\(viewController.children.count)"))
        properties.append(BMElementProperties(propertyName: "Parent VC", propertyValue: String(describing: type(of: viewController.parent ?? NSObject()))))
        
        if viewController.isViewLoaded {
            properties.append(BMElementProperties(propertyName: "View Frame", propertyValue: "\(viewController.view.frame)"))
            properties.append(BMElementProperties(propertyName: "View Hidden", propertyValue: "\(viewController.view.isHidden)"))
        }
        
        let elementInfo = BMElementInformation(
            image: nil,
            elementName: elementName,
            elementType: "UIViewController",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
    
    private func captureUnhandledType(_ value: Any, label: String?) {
        let elementName = label ?? "No label found"
        let properties = [BMElementProperties(propertyName: "Type", propertyValue: "\(type(of: value))")]
        
        let elementInfo = BMElementInformation(
            image: nil,
            elementName: elementName,
            elementType: "Unhandled Type",
            properties: properties
        )
        
        // Add to manager instead of logging
        BMElementManager.shared.addElement(elementInfo, forController: controllerName)
    }
}

extension UIView {
    var name: String { String(describing: Mirror(reflecting: self).subjectType) }
}

extension UIImage {
    var data: Data { pngData()! }
}
