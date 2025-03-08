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
        print("Controller: \(controllerName)")
        for child in Mirror(reflecting: self).children {
            switch child.value {
            case let button as UIButton:
                print("Captured UIButton: \(String(describing: type(of: button)))")
            case let label as UILabel:
                print("Captured UILabel: \(String(describing: type(of: label)))")
            case let imageView as UIImageView:
                print("Captured UIImageView: \(String(describing: type(of: imageView)))")
            case let textField as UITextField:
                print("Captured UITextField: \(String(describing: type(of: textField)))")
            case let textView as UITextView:
                print("Captured UITextView: \(String(describing: type(of: textView)))")
            case let scrollView as UIScrollView:
                print("Captured UIScrollView: \(String(describing: type(of: scrollView)))")
            case let tableView as UITableView:
                print("Captured UITableView: \(String(describing: type(of: tableView)))")
            case let collectionView as UICollectionView:
                print("Captured UICollectionView: \(String(describing: type(of: collectionView)))")
            case let stackView as UIStackView:
                print("Captured UIStackView: \(String(describing: type(of: stackView)))")
            case let switchControl as UISwitch:
                print("Captured UISwitch: \(String(describing: type(of: switchControl)))")
            case let view as UIView:
                print("Captured UIView: \(String(describing: type(of: view)))")
            case let viewController as UIViewController:
                print("Captured UIViewController: \(String(describing: type(of: viewController)))")
            default:
                break
            }
        }
    }
}
