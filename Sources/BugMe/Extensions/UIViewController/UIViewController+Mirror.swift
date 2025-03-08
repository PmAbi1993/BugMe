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
                let label: String = child.label ?? "No label found"
                osLog("Captured UIButton: \(label)")
                osLog("-- Properties --")
                osLog("  - Title: \(button.title(for: .normal) ?? "nil")")
                osLog("  - State: \(button.state.rawValue)")
                osLog("  - Enabled: \(button.isEnabled)")
                osLog("  - Hidden: \(button.isHidden)")
                osLog("  - Frame: \(button.frame)")
                osLog("  - Tag: \(button.tag)")
                if let imageData = button.currentImage?.pngData() {
                    let path = try? saveToDocuments(data: imageData, fileName: "button_\(label)_image", fileExtension: "png")
                    osLog("  - Image Path: \(path?.absoluteString ?? "nil")")
                }

            case let label as UILabel:
                let name = child.label ?? "No label found"
                osLog("Captured UILabel: \(name)")
                osLog("-- Properties --")
                osLog("  - Text: \(label.text ?? "nil")")
                osLog("  - Text Color: \(label.textColor)")
                osLog("  - Font: \(label.font)")
                osLog("  - Lines: \(label.numberOfLines)")
                osLog("  - Alignment: \(label.textAlignment.rawValue)")
                osLog("  - Hidden: \(label.isHidden)")
                osLog("  - Frame: \(label.frame)")

            case let imageView as UIImageView:
                let name = child.label ?? "No label found"
                osLog("Captured UIImageView: \(name)")
                osLog("-- Properties --")
                osLog("  - Content Mode: \(imageView.contentMode.rawValue)")
                osLog("  - Has Image: \(imageView.image != nil)")
                osLog("  - Hidden: \(imageView.isHidden)")
                osLog("  - Frame: \(imageView.frame)")
                if let imageData = imageView.image?.pngData() {
                    let path = try? saveToDocuments(data: imageData, fileName: "imageView_\(name)_image", fileExtension: "png")
                    osLog("  - Image Path: \(path?.absoluteString ?? "nil")")
                }

            case let textField as UITextField:
                let name = child.label ?? "No label found"
                osLog("Captured UITextField: \(name)")
                osLog("-- Properties --")
                osLog("  - Text: \(textField.text ?? "nil")")
                osLog("  - Placeholder: \(textField.placeholder ?? "nil")")
                osLog("  - Text Color: \(textField.textColor ?? .black)")
                osLog("  - Font: \(textField.font ?? UIFont.systemFont(ofSize: 14))")
                osLog("  - Alignment: \(textField.textAlignment.rawValue)")
                osLog("  - Is Editing: \(textField.isEditing)")
                osLog("  - Is Secure: \(textField.isSecureTextEntry)")
                osLog("  - Keyboard Type: \(textField.keyboardType.rawValue)")
                osLog("  - Hidden: \(textField.isHidden)")
                osLog("  - Frame: \(textField.frame)")

            case let textView as UITextView:
                let name = child.label ?? "No label found"
                osLog("Captured UITextView: \(name)")
                osLog("-- Properties --")
                osLog("  - Text: \(textView.text)")
                osLog("  - Text Color: \(textView.textColor ?? .black)")
                osLog("  - Font: \(textView.font ?? UIFont.systemFont(ofSize: 14))")
                osLog("  - Editable: \(textView.isEditable)")
                osLog("  - Selectable: \(textView.isSelectable)")
                osLog("  - Alignment: \(textView.textAlignment.rawValue)")
                osLog("  - Hidden: \(textView.isHidden)")
                osLog("  - Frame: \(textView.frame)")

            case let tableView as UITableView:
                let name = child.label ?? "No label found"
                osLog("Captured UITableView: \(name)")
                osLog("-- Properties --")
                osLog("  - Number of Sections: \(tableView.numberOfSections)")
                osLog("  - Style: \(tableView.style.rawValue)")
                osLog("  - Separator Style: \(tableView.separatorStyle.rawValue)")
                osLog("  - Row Height: \(tableView.rowHeight)")
                osLog("  - Allows Selection: \(tableView.allowsSelection)")
                osLog("  - Allows Multiple Selection: \(tableView.allowsMultipleSelection)")
                osLog("  - Hidden: \(tableView.isHidden)")
                osLog("  - Frame: \(tableView.frame)")
                
                let screenShot = tableView.captureTableViewScreenshots()
                let combinedImage = screenShot.combineImagesVertically()
                if let pngData = combinedImage.pngData() {
                    let path = try? saveToDocuments(data: pngData, fileName: "tableView_\(name)", fileExtension: "jpg")
                    osLog("  - Screenshot Path: \(path?.absoluteString ?? "nil")")
                }

            case let collectionView as UICollectionView:
                let name = child.label ?? "No label found"
                osLog("Captured UICollectionView: \(name)")
                osLog("-- Properties --")
                osLog("  - Number of Sections: \(collectionView.numberOfSections)")
                osLog("  - Allows Selection: \(collectionView.allowsSelection)")
                osLog("  - Allows Multiple Selection: \(collectionView.allowsMultipleSelection)")
                osLog("  - Hidden: \(collectionView.isHidden)")
                osLog("  - Frame: \(collectionView.frame)")
                if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    osLog("  - Item Size: \(layout.itemSize)")
                    osLog("  - Scroll Direction: \(layout.scrollDirection == .vertical ? "Vertical" : "Horizontal")")
                }

            case let stackView as UIStackView:
                let name = child.label ?? "No label found"
                osLog("Captured UIStackView: \(name)")
                osLog("-- Properties --")
                osLog("  - Axis: \(stackView.axis == .horizontal ? "Horizontal" : "Vertical")")
                osLog("  - Alignment: \(stackView.alignment.rawValue)")
                osLog("  - Distribution: \(stackView.distribution.rawValue)")
                osLog("  - Spacing: \(stackView.spacing)")
                osLog("  - Arranged Subviews Count: \(stackView.arrangedSubviews.count)")
                osLog("  - Hidden: \(stackView.isHidden)")
                osLog("  - Frame: \(stackView.frame)")

            case let switchControl as UISwitch:
                let name = child.label ?? "No label found"
                osLog("Captured UISwitch: \(name)")
                osLog("-- Properties --")
                osLog("  - Is On: \(switchControl.isOn)")
                osLog("  - Enabled: \(switchControl.isEnabled)")
                osLog("  - On Tint Color: \(switchControl.onTintColor ?? .systemBlue)")
                osLog("  - Thumb Tint Color: \(switchControl.thumbTintColor ?? .white)")
                osLog("  - Hidden: \(switchControl.isHidden)")
                osLog("  - Frame: \(switchControl.frame)")

            case let scrollView as UIScrollView:
                let name = child.label ?? "No label found"
                osLog("Captured UIScrollView: \(name)")
                osLog("-- Properties --")
                osLog("  - Content Size: \(scrollView.contentSize)")
                osLog("  - Content Offset: \(scrollView.contentOffset)")
                osLog("  - Content Inset: \(scrollView.contentInset)")
                osLog("  - Bounces: \(scrollView.bounces)")
                osLog("  - Paging Enabled: \(scrollView.isPagingEnabled)")
                osLog("  - Shows Indicators: H:\(scrollView.showsHorizontalScrollIndicator) V:\(scrollView.showsVerticalScrollIndicator)")
                osLog("  - Hidden: \(scrollView.isHidden)")
                osLog("  - Frame: \(scrollView.frame)")

            case let view as UIView:
                let name = child.label ?? "No label found"
                osLog("Captured UIView: \(name)")
                osLog("-- Properties --")
                osLog("  - Background Color: \(view.backgroundColor ?? .clear)")
                osLog("  - Alpha: \(view.alpha)")
                osLog("  - Is User Interaction Enabled: \(view.isUserInteractionEnabled)")
                osLog("  - Tag: \(view.tag)")
                osLog("  - Hidden: \(view.isHidden)")
                osLog("  - Frame: \(view.frame)")
                osLog("  - Subviews Count: \(view.subviews.count)")
                osLog("  - Layer Properties: Corner Radius: \(view.layer.cornerRadius), Border Width: \(view.layer.borderWidth)")

            case let viewController as UIViewController:
                let name = child.label ?? "No label found"
                osLog("Captured UIViewController: \(name)")
                osLog("-- Properties --")
                osLog("  - Title: \(viewController.title ?? "nil")")
                osLog("  - View Loaded: \(viewController.isViewLoaded)")
                osLog("  - Presentation Style: \(viewController.modalPresentationStyle.rawValue)")
                osLog("  - Transition Style: \(viewController.modalTransitionStyle.rawValue)")
                osLog("  - Child VCs Count: \(viewController.children.count)")
                osLog("  - Parent VC: \(String(describing: type(of: viewController.parent ?? NSObject())))")
                if viewController.isViewLoaded {
                    osLog("  - View Frame: \(viewController.view.frame)")
                    osLog("  - View Hidden: \(viewController.view.isHidden)")
                }

            default:
                if let label = child.label {
                    osLog("Unhandled type for '\(label)': \(type(of: child.value))")
                } else {
                    osLog("Unhandled type (no label): \(type(of: child.value))")
                }
            }
        }
    }
}

extension UIView {
    var name: String { String(describing: Mirror(reflecting: self).subjectType) }
}

extension UIImage {
    var data: Data { pngData()! }
}
