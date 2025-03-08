//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import UIKit

// Requirement
// Loop through the array and combine the images as a single image vertically.
extension Array where Iterator.Element == UIImage {
    
    /// Combines an array of UIImages into a single UIImage stacked vertically
    /// - Returns: A single UIImage containing all images stacked vertically
    func combineImagesVertically() -> UIImage {
        // Return empty image if array is empty
        guard !isEmpty else { return UIImage() }
        
        // If only one image, return it directly
        if count == 1, let firstImage = first {
            return firstImage
        }
        
        // Calculate total height and maximum width
        var totalHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        for image in self {
            totalHeight += image.size.height
            maxWidth = Swift.max(maxWidth, image.size.width)
        }
        
        // Create a new image context with the calculated dimensions
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: maxWidth, height: totalHeight))
        
        // Render all images into the context
        return renderer.image { context in
            var currentY: CGFloat = 0
            
            for image in self {
                image.draw(at: CGPoint(x: 0, y: currentY))
                currentY += image.size.height
            }
        }
    }
}
