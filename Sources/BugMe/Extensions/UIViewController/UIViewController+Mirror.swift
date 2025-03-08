//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import UIKit

public extension UIViewController {
    var controllerName: String { String(describing: type(of: self)) }
    
    func capture() {
        let controllerName: String = String(describing: type(of: self))
        osLog("Controller: \(controllerName)")
        for child in Mirror(reflecting: self).children {
            switch child.value {
            case let button as UIButton:
                let label: String = child.label ?? "No label found"
                osLog("Captured UIButton: \(label)))")
            case let label as UILabel:
                osLog("Captured UILabel: \(String(describing: type(of: label)))")
            case let imageView as UIImageView:
                osLog("Captured UIImageView: \(String(describing: type(of: imageView)))")
            case let textField as UITextField:
                osLog("Captured UITextField: \(String(describing: type(of: textField)))")
            case let textView as UITextView:
                osLog("Captured UITextView: \(String(describing: type(of: textView)))")
            case let tableView as UITableView:
                let screenShot = tableView.captureTableViewScreenshots()
                let combinedImage = screenShot.combineImagesVertically()
                if let pngData = combinedImage.pngData() {
                    let path = try? saveToDocuments(data: pngData, fileName: "tableView", fileExtension: "jpg")
                    osLog(path?.absoluteString ?? "", subsystem: "print")
                }
                osLog("Captured UITableView: \(String(describing: type(of: tableView)))")
            case let collectionView as UICollectionView:
                osLog("Captured UICollectionView: \(String(describing: type(of: collectionView)))")
            case let stackView as UIStackView:
                osLog("Captured UIStackView: \(String(describing: type(of: stackView)))")
            case let switchControl as UISwitch:
                osLog("Captured UISwitch: \(String(describing: type(of: switchControl)))")
            case let view as UIView:
                osLog("Captured UIView: \(String(describing: type(of: view)))")
            case let scrollView as UIScrollView:
                osLog("Captured UIScrollView: \(String(describing: type(of: scrollView)))")
            case let viewController as UIViewController:
                osLog("Captured UIViewController: \(String(describing: type(of: viewController)))")
            default:
                break
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
