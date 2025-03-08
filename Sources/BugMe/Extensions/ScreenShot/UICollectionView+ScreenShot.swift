//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import UIKit

public extension UICollectionView {
    
    /// Captures a screenshot of a specific cell in the collection view
    /// - Parameter indexPath: The indexPath of the cell to screenshot
    /// - Returns: UIImage of the cell or nil if cell doesn't exist
    func screenshotCell(at indexPath: IndexPath) -> UIImage? {
        // Scroll to make the cell visible first
        scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        
        // Wait for scrolling to complete
        layoutIfNeeded()
        
        // Get the cell
        guard let cell = cellForItem(at: indexPath) else { return nil }
        
        // Take screenshot of the cell
        return cell.screenshot()
    }
    
    /// Captures a screenshot of a section header
    /// - Parameter section: The section index
    /// - Returns: UIImage of the header or nil if header doesn't exist
    func screenshotSectionHeader(at section: Int) -> UIImage? {
        // Get the supplementary view for header
        guard let headerView = supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) else { return nil }
        
        // Take screenshot of the header
        return headerView.screenshot()
    }
    
    /// Captures a screenshot of a section footer
    /// - Parameter section: The section index
    /// - Returns: UIImage of the footer or nil if footer doesn't exist
    func screenshotSectionFooter(at section: Int) -> UIImage? {
        // Get the supplementary view for footer
        guard let footerView = supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section)) else { return nil }
        
        // Take screenshot of the footer
        return footerView.screenshot()
    }
    
    /// Captures the entire collection view content by stitching all sections, headers and footers
    /// - Returns: UIImage of the entire collection view content
    func screenshotEntireContent() -> UIImage? {
        // Save current content offset and zoom scale
        let savedContentOffset = contentOffset
        let savedFrame = frame
        
        // Calculate the size of the entire content
        let contentSize = collectionViewLayout.collectionViewContentSize
        if contentSize.height == 0 || contentSize.width == 0 { return nil }
        
        // Setup an image context with the content size
        UIGraphicsBeginImageContextWithOptions(contentSize, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        let backgroundColor = backgroundColor ?? .white
        context.setFillColor(backgroundColor.cgColor)
        context.fill(CGRect(origin: .zero, size: contentSize))
        
        // Temporarily adjust the collection view's frame to content size
        frame = CGRect(origin: frame.origin, size: contentSize)
        
        // Iterate through all sections and items
        let numberOfSections = numberOfSections
        
        for section in 0..<numberOfSections {
            // Capture section header
            if let headerView = supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
                let headerRect = layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))?.frame ?? .zero
                
                // Set new offset and draw header
                contentOffset = CGPoint(x: 0, y: headerRect.origin.y)
                layer.render(in: context)
            }
            
            // Capture all cells in this section
            let numberOfItems = numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                if let cellAttributes = layoutAttributesForItem(at: indexPath) {
                    // Set offset to cell position and render
                    contentOffset = CGPoint(x: cellAttributes.frame.origin.x, y: cellAttributes.frame.origin.y)
                    layer.render(in: context)
                }
            }
            
            // Capture section footer
            if let footerView = supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section)) {
                let footerRect = layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section))?.frame ?? .zero
                
                // Set new offset and draw footer
                contentOffset = CGPoint(x: 0, y: footerRect.origin.y)
                layer.render(in: context)
            }
        }
        
        // Get the image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Restore original settings
        frame = savedFrame
        contentOffset = savedContentOffset
        
        return image
    }
    
    /// Takes a screenshot of the visible area of the collection view
    /// - Returns: UIImage of the visible portion of the collection view
    func screenshotVisibleArea() -> UIImage? {
        return screenshot()
    }
    
    /// Takes a screenshot of a specific rectangular area in the collection view's content
    /// - Parameter rect: The rect in the collection view's content coordinates to capture
    /// - Returns: UIImage of the specified rect
    func screenshot(of rect: CGRect) -> UIImage? {
        // Save current state
        let savedContentOffset = contentOffset
        
        // Scroll to the rectangle's position
        contentOffset = CGPoint(x: rect.minX, y: rect.minY)
        layoutIfNeeded()
        
        // Setup image context with the rect size
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        // Set clip to rect
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: -rect.minX + contentOffset.x, y: -rect.minY + contentOffset.y)
        layer.render(in: context)
        
        // Get the image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Restore original offset
        contentOffset = savedContentOffset
        
        return image
    }
}

// MARK: - UIView Screenshot Helper
private extension UIView {
    /// Captures a screenshot of the view
    /// - Returns: UIImage representation of the view
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
