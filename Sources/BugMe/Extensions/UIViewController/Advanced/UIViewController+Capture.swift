//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 9/3/25.
//

import UIKit

extension UIViewController {
    // TODO: Move to appropriate place
    var controllerName: String { String(describing: type(of: self)) }
    
    public func captureAllItems() {
        let children = Mirror(reflecting: self).children
        var vcItems: [BMBlockItem] = []
        children.forEach { child in
            switch child.value {
            case let button as UIButton:
                let buttonDetailCapture = ButtonDetailCapture(button: button, title: child.label)
                vcItems.append(buttonDetailCapture.getButtonDetails())
            case let label as UILabel:
                let labelDetailCapture = LabelDetailCapture(label: label, title: child.label)
                vcItems.append(labelDetailCapture.getLabelDetails())
            case let imageView as UIImageView:
                let imageDetailCapture = ImageViewDetailCapture(imageView: imageView, title: child.label)
                vcItems.append(imageDetailCapture.getImageViewDetails())
            case let textField as UITextField:
                let textFieldDetailCapture = TextFieldDetailCapture(textField: textField, title: child.label)
                vcItems.append(textFieldDetailCapture.getTextFieldDetails())
            case let textView as UITextView:
                let textViewDetailCapture = TextViewDetailCapture(textView: textView, title: child.label)
                vcItems.append(textViewDetailCapture.getTextViewDetails())
            case let tableView as UITableView:
                let tableViewDetailCapture = TableViewDetailCapture(tableView: tableView, title: child.label)
                vcItems.append(tableViewDetailCapture.getTableViewDetails())
            case let collectionView as UICollectionView:
                let collectionViewDetailCapture = CollectionViewDetailCapture(collectionView: collectionView, title: child.label)
                vcItems.append(collectionViewDetailCapture.getCollectionViewDetails())
            case let stackView as UIStackView:
                let stackViewDetailCapture = StackViewDetailCapture(stackView: stackView, title: child.label)
                vcItems.append(stackViewDetailCapture.getStackViewDetails())
            case let switchControl as UISwitch:
                let switchControlDetailCapture = SwitchControlDetailCapture(switchControl: switchControl, title: child.label)
                vcItems.append(switchControlDetailCapture.getSwitchDetails())
            case let scrollView as UIScrollView:
                let scrollViewDetailCapture = ScrollViewDetailCapture(scrollView: scrollView, title: child.label)
                vcItems.append(scrollViewDetailCapture.getScrollViewDetails())
            case let view as UIView:
                let viewDetailCapture = ViewDetailCapture(view: view, title: child.label)
                vcItems.append(viewDetailCapture.getViewDetails())
            default:
                if let title = child.label {
                    let properties: [BMBlockItemProperties] = []
                    let defaultItem = BMBlockItem(imagePath: nil, title: title, properties: properties)
                    vcItems.append(defaultItem)
                }
            }
        }
        let filePath = try? self.view.takeScreenshot(fileName: controllerName).filePath.absoluteString
        let controllerInformation = BMBlock(
            controller: controllerName,
            imagePath: filePath,
            elements: vcItems
        )
        BugMeViewManager.shared.addBlock(block: controllerInformation)
        BugMeViewManager.shared.generateReport()
    }
}
