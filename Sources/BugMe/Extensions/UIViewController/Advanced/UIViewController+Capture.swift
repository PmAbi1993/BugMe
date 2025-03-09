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
    
    func captureAllItems() {
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
                break
            case let textField as UITextField:
                break
            case let textView as UITextView:
                break
            case let tableView as UITableView:
                break
            case let collectionView as UICollectionView:
                break
            case let stackView as UIStackView:
                break
            case let switchControl as UISwitch:
                break
            case let scrollView as UIScrollView:
                break
            case let view as UIView:
                break
            default:
                break
            }
        }
        let filePath = try? self.view.takeScreenshot(fileName: controllerName).filePath.absoluteString
        let controllerInformation = BMBlock(
            controller: controllerName,
            imagePath: filePath,
            elements: vcItems
        )
        BugMeViewManager.shared.addBlock(block: controllerInformation)
    }
}
