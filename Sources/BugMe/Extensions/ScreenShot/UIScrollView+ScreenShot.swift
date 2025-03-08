//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import Foundation
import UIKit

extension UIScrollView {
    /// Captures the entire content of a UIScrollView, including offscreen content
    /// - Returns: The captured UIImage or nil if capture fails
    public func captureEntireScrollView() -> UIImage? {
        // Save current state
        let originalOffset = contentOffset
        let originalFrame = frame
        let originalInsets = contentInset
        
        // Temporarily remove insets for accurate capture
        contentInset = .zero
        
        // Ensure we have valid content size
        if contentSize.width <= 0 || contentSize.height <= 0 {
            return nil
        }
        
        // Create a properly sized bitmap context
        let contentRect = CGRect(origin: .zero, size: contentSize)
        UIGraphicsBeginImageContextWithOptions(contentSize, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            // Restore original state
            contentOffset = originalOffset
            contentInset = originalInsets
            return nil
        }
        
        // Clear context to ensure transparency
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(contentRect)
        
        // Capture the scrollview content synchronously
        let success = captureScrollViewBySegments(originalOffset: originalOffset, originalFrame: originalFrame)
        
        // Generate the final image
        let fullImage = success ? UIGraphicsGetImageFromCurrentImageContext() : nil
        UIGraphicsEndImageContext()
        
        // Restore original state
        self.contentOffset = originalOffset
        self.contentInset = originalInsets
        
        // Return the image
        return fullImage
    }
    
    /// Helper method to capture the scroll view by iterating through segments
    /// Returns whether the capture was successful
    private func captureScrollViewBySegments(originalOffset: CGPoint, originalFrame: CGRect) -> Bool {
        // Calculate the number of pages in width and height directions
        let pages = calculatePages(frameSize: originalFrame.size)
        var captureSucceeded = true
        
        // Iterate through all calculated segments
        for yPage in 0..<pages.y {
            for xPage in 0..<pages.x {
                // Calculate offset for this segment
                let xOffset = CGFloat(xPage) * originalFrame.size.width
                let yOffset = CGFloat(yPage) * originalFrame.size.height
                let offset = CGPoint(x: xOffset, y: yOffset)
                
                // Set offset
                contentOffset = offset
                
                // Draw this segment into the context at the appropriate position
                drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
                
                // Translate the context to place this segment correctly
                if let context = UIGraphicsGetCurrentContext() {
                    context.translateBy(x: xOffset, y: yOffset)
                    layer.render(in: context)
                    context.translateBy(x: -xOffset, y: -yOffset)
                } else {
                    captureSucceeded = false
                }
            }
        }
        
        return captureSucceeded
    }
    
    /// Calculate how many "pages" we need to capture based on content size
    private func calculatePages(frameSize: CGSize) -> (x: Int, y: Int) {
        let xPages = Int(ceil(contentSize.width / frameSize.width))
        let yPages = Int(ceil(contentSize.height / frameSize.height))
        return (x: xPages, y: yPages)
    }
}
