//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import Foundation
import UIKit

public extension UIView {
    
    /// Captures a screenshot of the current view and returns it as a UIImage
    /// - Returns: UIImage representation of the view
    func takeScreenshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let screenshot = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        
        return screenshot
    }
    
    /// Image format options for screenshot export
    enum ScreenshotFormat {
        case png
        case jpeg
    }
    
    /// Captures a screenshot of the current view and returns it as Data with specified format and compression quality
    /// - Parameters:
    ///   - format: The format to use for the image data (default: .png)
    ///   - compressionQuality: The quality of the resulting image (0.0 to 1.0, where 1.0 is maximum quality)
    /// - Returns: Data representation of the image or nil if conversion fails
    func takeScreenshotAsData(format: ScreenshotFormat = .png, compressionQuality: CGFloat = 1.0) -> Data? {
        let screenshot = takeScreenshot()
        
        switch format {
        case .png:
            return screenshot.pngData()
        case .jpeg:
            return screenshot.jpegData(compressionQuality: compressionQuality)
        }
    }
}
