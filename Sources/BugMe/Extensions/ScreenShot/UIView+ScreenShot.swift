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

    /// Takes a screenshot of a UIView and saves it to the documents directory
/// - Parameters:
///   - fileName: Base name for the screenshot file (without extension)
/// - Returns: Tuple containing the UIImage and the URL where it was saved
/// - Throws: Error if unable to create image data or save to documents directory
public func takeScreenshot(fileName: String = "screenshot") throws -> (image: UIImage, filePath: URL) {
    // Create a renderer with the same size as the view
    let renderer = UIGraphicsImageRenderer(size: bounds.size)
    
    // Render the view into an image
    let image = renderer.image { ctx in
        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
    }
    
    // Convert the image to data
    guard let imageData = image.pngData() else {
        throw NSError(domain: "ScreenshotError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to create PNG data from screenshot"])
    }
    
    // Save the image data to documents directory
    let filePath = try saveToDocuments(data: imageData, fileName: fileName, fileExtension: "png")
    
    return (image, filePath)
}
}
