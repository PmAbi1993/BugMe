//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import UIKit
import OSLog

public extension UIViewController {
    var controllerName: String { String(describing: type(of: self)) }
    
    func capture() {
        let controllerName: String = String(describing: type(of: self))
        osLog("Controller: \(controllerName)")
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
    }
    
    // MARK: - UI Element Capture Methods
    
    private func captureButton(_ button: UIButton, label: String?) {
        let name = label ?? "No label found"
        var properties = "Captured UIButton: \(name)\n"
        properties += "-- Properties --\n"
        properties += "  - Title: \(button.title(for: .normal) ?? "nil")\n"
        properties += "  - State: \(button.state.rawValue)\n"
        properties += "  - Enabled: \(button.isEnabled)\n"
        properties += "  - Hidden: \(button.isHidden)\n"
        properties += "  - Frame: \(button.frame)\n"
        properties += "  - Tag: \(button.tag)"
        
        if let imageData = button.currentImage?.pngData() {
            let path = try? saveToDocuments(data: imageData, fileName: "button_\(name)_image", fileExtension: "png")
            properties += "\n  - Image Path: \(path?.absoluteString ?? "nil")"
        }
        osLog(properties)
    }
    
    private func captureLabel(_ label: UILabel, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UILabel: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Text: \(label.text ?? "nil")\n"
        properties += "  - Text Color: \(label.textColor)\n"
        properties += "  - Font: \(label.font)\n"
        properties += "  - Lines: \(label.numberOfLines)\n"
        properties += "  - Alignment: \(label.textAlignment.rawValue)\n"
        properties += "  - Hidden: \(label.isHidden)\n"
        properties += "  - Frame: \(label.frame)"
        osLog(properties)
    }
    
    private func captureImageView(_ imageView: UIImageView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UIImageView: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Content Mode: \(imageView.contentMode.rawValue)\n"
        properties += "  - Has Image: \(imageView.image != nil)\n"
        properties += "  - Hidden: \(imageView.isHidden)\n"
        properties += "  - Frame: \(imageView.frame)"
        
        if let imageData = imageView.image?.pngData() {
            let path = try? saveToDocuments(data: imageData, fileName: "imageView_\(elementName)_image", fileExtension: "png")
            properties += "\n  - Image Path: \(path?.absoluteString ?? "nil")"
        }
        osLog(properties)
    }
    
    private func captureTextField(_ textField: UITextField, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UITextField: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Text: \(textField.text ?? "nil")\n"
        properties += "  - Placeholder: \(textField.placeholder ?? "nil")\n"
        properties += "  - Text Color: \(textField.textColor ?? .black)\n"
        properties += "  - Font: \(textField.font ?? UIFont.systemFont(ofSize: 14))\n"
        properties += "  - Alignment: \(textField.textAlignment.rawValue)\n"
        properties += "  - Is Editing: \(textField.isEditing)\n"
        properties += "  - Is Secure: \(textField.isSecureTextEntry)\n"
        properties += "  - Keyboard Type: \(textField.keyboardType.rawValue)\n"
        properties += "  - Hidden: \(textField.isHidden)\n"
        properties += "  - Frame: \(textField.frame)"
        osLog(properties)
    }
    
    private func captureTextView(_ textView: UITextView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UITextView: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Text: \(textView.text)\n"
        properties += "  - Text Color: \(textView.textColor ?? .black)\n"
        properties += "  - Font: \(textView.font ?? UIFont.systemFont(ofSize: 14))\n"
        properties += "  - Editable: \(textView.isEditable)\n"
        properties += "  - Selectable: \(textView.isSelectable)\n"
        properties += "  - Alignment: \(textView.textAlignment.rawValue)\n"
        properties += "  - Hidden: \(textView.isHidden)\n"
        properties += "  - Frame: \(textView.frame)"
        osLog(properties)
    }
    
    private func captureTableView(_ tableView: UITableView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UITableView: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Number of Sections: \(tableView.numberOfSections)\n"
        properties += "  - Style: \(tableView.style.rawValue)\n"
        properties += "  - Separator Style: \(tableView.separatorStyle.rawValue)\n"
        properties += "  - Row Height: \(tableView.rowHeight)\n"
        properties += "  - Allows Selection: \(tableView.allowsSelection)\n"
        properties += "  - Allows Multiple Selection: \(tableView.allowsMultipleSelection)\n"
        properties += "  - Hidden: \(tableView.isHidden)\n"
        properties += "  - Frame: \(tableView.frame)"
        
        let screenShot = tableView.captureTableViewScreenshots()
        let combinedImage = screenShot.combineImagesVertically()
        if let pngData = combinedImage.pngData() {
            let path = try? saveToDocuments(data: pngData, fileName: "tableView_\(elementName)", fileExtension: "jpg")
            properties += "\n  - Screenshot Path: \(path?.absoluteString ?? "nil")"
        }
        osLog(properties)
    }
    
    private func captureCollectionView(_ collectionView: UICollectionView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UICollectionView: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Number of Sections: \(collectionView.numberOfSections)\n"
        properties += "  - Allows Selection: \(collectionView.allowsSelection)\n"
        properties += "  - Allows Multiple Selection: \(collectionView.allowsMultipleSelection)\n"
        properties += "  - Hidden: \(collectionView.isHidden)\n"
        properties += "  - Frame: \(collectionView.frame)"
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            properties += "\n  - Item Size: \(layout.itemSize)\n"
            properties += "  - Scroll Direction: \(layout.scrollDirection == .vertical ? "Vertical" : "Horizontal")"
        }
        osLog(properties)
    }
    
    private func captureStackView(_ stackView: UIStackView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UIStackView: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Axis: \(stackView.axis == .horizontal ? "Horizontal" : "Vertical")\n"
        properties += "  - Alignment: \(stackView.alignment.rawValue)\n"
        properties += "  - Distribution: \(stackView.distribution.rawValue)\n"
        properties += "  - Spacing: \(stackView.spacing)\n"
        properties += "  - Arranged Subviews Count: \(stackView.arrangedSubviews.count)\n"
        properties += "  - Hidden: \(stackView.isHidden)\n"
        properties += "  - Frame: \(stackView.frame)"
        osLog(properties)
    }
    
    private func captureSwitch(_ switchControl: UISwitch, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UISwitch: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Is On: \(switchControl.isOn)\n"
        properties += "  - Enabled: \(switchControl.isEnabled)\n"
        properties += "  - On Tint Color: \(switchControl.onTintColor ?? .systemBlue)\n"
        properties += "  - Thumb Tint Color: \(switchControl.thumbTintColor ?? .white)\n"
        properties += "  - Hidden: \(switchControl.isHidden)\n"
        properties += "  - Frame: \(switchControl.frame)"
        osLog(properties)
    }
    
    private func captureScrollView(_ scrollView: UIScrollView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UIScrollView: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Content Size: \(scrollView.contentSize)\n"
        properties += "  - Content Offset: \(scrollView.contentOffset)\n"
        properties += "  - Content Inset: \(scrollView.contentInset)\n"
        properties += "  - Bounces: \(scrollView.bounces)\n"
        properties += "  - Paging Enabled: \(scrollView.isPagingEnabled)\n"
        properties += "  - Shows Indicators: H:\(scrollView.showsHorizontalScrollIndicator) V:\(scrollView.showsVerticalScrollIndicator)\n"
        properties += "  - Hidden: \(scrollView.isHidden)\n"
        properties += "  - Frame: \(scrollView.frame)"
        osLog(properties)
    }
    
    private func captureView(_ view: UIView, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UIView: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Background Color: \(view.backgroundColor ?? .clear)\n"
        properties += "  - Alpha: \(view.alpha)\n"
        properties += "  - Is User Interaction Enabled: \(view.isUserInteractionEnabled)\n"
        properties += "  - Tag: \(view.tag)\n"
        properties += "  - Hidden: \(view.isHidden)\n"
        properties += "  - Frame: \(view.frame)\n"
        properties += "  - Subviews Count: \(view.subviews.count)\n"
        properties += "  - Layer Properties: Corner Radius: \(view.layer.cornerRadius), Border Width: \(view.layer.borderWidth)"
        osLog(properties)
    }
    
    private func captureViewController(_ viewController: UIViewController, name: String?) {
        let elementName = name ?? "No label found"
        var properties = "Captured UIViewController: \(elementName)\n"
        properties += "-- Properties --\n"
        properties += "  - Title: \(viewController.title ?? "nil")\n"
        properties += "  - View Loaded: \(viewController.isViewLoaded)\n"
        properties += "  - Presentation Style: \(viewController.modalPresentationStyle.rawValue)\n"
        properties += "  - Transition Style: \(viewController.modalTransitionStyle.rawValue)\n"
        properties += "  - Child VCs Count: \(viewController.children.count)\n"
        properties += "  - Parent VC: \(String(describing: type(of: viewController.parent ?? NSObject())))"
        
        if viewController.isViewLoaded {
            properties += "\n  - View Frame: \(viewController.view.frame)\n"
            properties += "  - View Hidden: \(viewController.view.isHidden)"
        }
        osLog(properties)
    }
    
    private func captureUnhandledType(_ value: Any, label: String?) {
        var properties = ""
        if let label = label {
            properties = "Unhandled type for '\(label)': \(type(of: value))"
        } else {
            properties = "Unhandled type (no label): \(type(of: value))"
        }
        osLog(properties)
    }
}

extension UIView {
    var name: String { String(describing: Mirror(reflecting: self).subjectType) }
}

extension UIImage {
    var data: Data { pngData()! }
}
