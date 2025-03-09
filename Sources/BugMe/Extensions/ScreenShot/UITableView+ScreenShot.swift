import Foundation
import UIKit


// Logic used
//1. Create an array of images called tableScreenShots and initialise it as empty.
//2. Capture the initial offset of the UITableView in a variable currentOffset
//3. Scroll to indexPath 0,0
//4. Take screenshot of the UITableViewHeaderView and insert it to the tableScreenShots array.
//5. Now start a loop for all section and rows
//    1. Scroll to current section and row
//    2. Take screenshot of the UITableView section header view and store in the tableScreenShots array.
//    3. Scroll to cell, take screenshot and store it in tableScreenShots
//    4. Scroll to UITableViewFooterView, take a screenshot and insert it into tableScreenShots
//6. Once the function exists loop, Scroll to UITableViewFooterView
//7. Take screenshot and insert it into tableScreenShots


public extension UITableView {
    
    /// Captures screenshots of all components in a UITableView
    /// - Returns: Array of UIImage containing screenshots of all table components
    func captureTableViewScreenshots() -> [UIImage] {
        // 1. Create an array of images called tableScreenShots and initialise it as empty
        var tableScreenShots: [UIImage] = []
        
        // 2. Capture the initial offset of the UITableView in a variable currentOffset
        let currentOffset = contentOffset
        
        // 3. Scroll to indexPath 0,0
        if numberOfSections > 0 && numberOfRows(inSection: 0) > 0 {
            scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        // 4. Take screenshot of the UITableViewHeaderView and insert it to the tableScreenShots array
        if let tableHeaderView = tableHeaderView {
            tableScreenShots.append(tableHeaderView.takeScreenshot())
        }
        
        // 5. Start a loop for all sections and rows
        for section in 0..<numberOfSections {
            // 5.1 & 5.2. Get section header using delegate method instead of headerView(forSection:)
            // This ensures we capture section headers even when they're not currently visible
            let headerRect = rectForHeader(inSection: section)
            scrollRectToVisible(headerRect, animated: false)
            
            // Force layout to ensure the header view is properly configured
            layoutIfNeeded()
            
            // Now try to get the header view after ensuring it's visible
            if let sectionHeaderView = headerView(forSection: section) {
                tableScreenShots.append(sectionHeaderView.takeScreenshot())
            } else if let delegate = delegate as? UITableViewDelegate, 
                      let headerView = delegate.tableView?(self, viewForHeaderInSection: section) {
                // Try to get header view directly from delegate method if available
                tableScreenShots.append(headerView.takeScreenshot())
            }
            
            // 5.3. Scroll to each cell, take screenshot and store in tableScreenShots
            for row in 0..<numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                scrollToRow(at: indexPath, at: .top, animated: false)
                layoutIfNeeded() // Force layout to ensure cell is properly configured
                
                if let cell = cellForRow(at: indexPath) {
                    tableScreenShots.append(cell.takeScreenshot())
                }
            }
            
            // 5.4. Scroll to section footer, take a screenshot and insert it into tableScreenShots
            let footerRect = rectForFooter(inSection: section)
            scrollRectToVisible(footerRect, animated: false)
            layoutIfNeeded()
            
            if let sectionFooterView = footerView(forSection: section) {
                tableScreenShots.append(sectionFooterView.takeScreenshot())
            }
        }
        
        // 6. Once the function exits loop, Scroll to UITableViewFooterView
        // 7. Take screenshot and insert it into tableScreenShots
        if let tableFooterView = tableFooterView {
            scrollRectToVisible(tableFooterView.frame, animated: false)
            layoutIfNeeded()
            tableScreenShots.append(tableFooterView.takeScreenshot())
        }
        
        // Restore the original scroll position
        setContentOffset(currentOffset, animated: false)
        
        return tableScreenShots
    }

    func captureTableView(tableView: UITableView) -> UIImage? {
        // Ensure data source and delegate are set
        guard let dataSource = tableView.dataSource else {
            return nil
        }
        let delegate = tableView.delegate
        
        // Variable to track total height
        var totalHeight: CGFloat = 0
        
        // Add table header height
        if let header = tableView.tableHeaderView {
            totalHeight += header.frame.height
        }
        
        setContentOffset(.zero, animated: false)
        // Calculate height for all sections
        for section in 0..<tableView.numberOfSections {
            // Section header height
            let headerHeight = delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? tableView.sectionHeaderHeight
            totalHeight += headerHeight
            
            // Cells height
            let numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: section)
            for row in 0..<numberOfRows {
                let indexPath = IndexPath(row: row, section: section)
                let cellHeight = delegate?.tableView?(tableView, heightForRowAt: indexPath) ??
                                 (tableView.rowHeight != UITableView.automaticDimension ? tableView.rowHeight : 44.0)
                totalHeight += cellHeight
            }
            
            // Section footer height
            let footerHeight = delegate?.tableView?(tableView, heightForFooterInSection: section) ?? tableView.sectionFooterHeight
            totalHeight += footerHeight
        }
        
        // Add table footer height
        if let footer = tableView.tableFooterView {
            totalHeight += footer.frame.height
        }
        
        // Create renderer with table width and total height
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: tableView.frame.width, height: totalHeight))
        
        // Render the image
        let image = renderer.image { context in
            // Set background color
            context.cgContext.setFillColor(tableView.backgroundColor?.cgColor ?? UIColor.white.cgColor)
            context.cgContext.fill(CGRect(x: 0, y: 0, width: tableView.frame.width, height: totalHeight))
            
            var currentY: CGFloat = 0
            
            // Draw table header
            if let header = tableView.tableHeaderView {
                header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: header.frame.height)
                header.layoutIfNeeded()
                context.cgContext.saveGState()
                context.cgContext.translateBy(x: 0, y: currentY)
                header.layer.render(in: context.cgContext)
                context.cgContext.restoreGState()
                currentY += header.frame.height
            }
            
            // Draw each section
            for section in 0..<tableView.numberOfSections {
                // Draw section header
                if let headerView = delegate?.tableView?(tableView, viewForHeaderInSection: section) {
                    let headerHeight = delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? tableView.sectionHeaderHeight
                    headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)
                    headerView.layoutIfNeeded()
                    context.cgContext.saveGState()
                    context.cgContext.translateBy(x: 0, y: currentY)
                    headerView.layer.render(in: context.cgContext)
                    context.cgContext.restoreGState()
                    currentY += headerHeight
                }
                
                // Draw cells
                let numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: section)
                for row in 0..<numberOfRows {
                    let indexPath = IndexPath(row: row, section: section)
                    if let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? UITableViewCell {
                        let cellHeight = delegate?.tableView?(tableView, heightForRowAt: indexPath) ??
                                         (tableView.rowHeight != UITableView.automaticDimension ? tableView.rowHeight : 44.0)
                        cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: cellHeight)
                        
                        // Ensure cell is fully prepared
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                        cell.contentView.setNeedsLayout()
                        cell.contentView.layoutIfNeeded()
                        
                        // Debug: Print cell info
                        print("Rendering cell at \(indexPath) with frame: \(cell.frame), content: \(cell.contentView.subviews)")
                        
                        // Render with context translation
                        context.cgContext.saveGState()
                        context.cgContext.translateBy(x: 0, y: currentY)
                        cell.layer.render(in: context.cgContext)
                        context.cgContext.restoreGState()
                        currentY += cellHeight
                    }
                }
                
                // Draw section footer
                if let footerView = delegate?.tableView?(tableView, viewForFooterInSection: section) {
                    let footerHeight = delegate?.tableView?(tableView, heightForFooterInSection: section) ?? tableView.sectionFooterHeight
                    footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerHeight)
                    footerView.layoutIfNeeded()
                    context.cgContext.saveGState()
                    context.cgContext.translateBy(x: 0, y: currentY)
                    footerView.layer.render(in: context.cgContext)
                    context.cgContext.restoreGState()
                    currentY += footerHeight
                }
            }
            
            // Draw table footer
            if let footer = tableView.tableFooterView {
                footer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footer.frame.height)
                footer.layoutIfNeeded()
                context.cgContext.saveGState()
                context.cgContext.translateBy(x: 0, y: currentY)
                footer.layer.render(in: context.cgContext)
                context.cgContext.restoreGState()
            }
        }
        
        return image
    }
}



//func captureTableView(tableView: UITableView) -> UIImage? {
//    // Ensure data source and delegate are set
//    guard let dataSource = tableView.dataSource else {
//        return nil
//    }
//    let delegate = tableView.delegate
//    
//    // Variable to track total height
//    var totalHeight: CGFloat = 0
//    
//    // Add table header height
//    if let header = tableView.tableHeaderView {
//        totalHeight += header.frame.height
//    }
//    
//    // Calculate height for all sections
//    for section in 0..<tableView.numberOfSections {
//        // Section header height
//        let headerHeight = delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? tableView.sectionHeaderHeight
//        totalHeight += headerHeight
//        
//        // Cells height
//        let numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: section)
//        for row in 0..<numberOfRows {
//            let indexPath = IndexPath(row: row, section: section)
//            let cellHeight = delegate?.tableView?(tableView, heightForRowAt: indexPath) ??
//                             (tableView.rowHeight != UITableView.automaticDimension ? tableView.rowHeight : 44.0)
//            totalHeight += cellHeight
//        }
//        
//        // Section footer height
//        let footerHeight = delegate?.tableView?(tableView, heightForFooterInSection: section) ?? tableView.sectionFooterHeight
//        totalHeight += footerHeight
//    }
//    
//    // Add table footer height
//    if let footer = tableView.tableFooterView {
//        totalHeight += footer.frame.height
//    }
//    
//    // Create renderer with table width and total height
//    let renderer = UIGraphicsImageRenderer(size: CGSize(width: tableView.frame.width, height: totalHeight))
//    
//    // Render the image
//    let image = renderer.image { context in
//        // Set background color
//        context.cgContext.setFillColor(tableView.backgroundColor?.cgColor ?? UIColor.white.cgColor)
//        context.cgContext.fill(CGRect(x: 0, y: 0, width: tableView.frame.width, height: totalHeight))
//        
//        var currentY: CGFloat = 0
//        
//        // Draw table header
//        if let header = tableView.tableHeaderView {
//            header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: header.frame.height)
//            header.layoutIfNeeded()
//            context.cgContext.saveGState()
//            context.cgContext.translateBy(x: 0, y: currentY)
//            header.layer.render(in: context.cgContext)
//            context.cgContext.restoreGState()
//            currentY += header.frame.height
//        }
//        
//        // Draw each section
//        for section in 0..<tableView.numberOfSections {
//            // Draw section header
//            if let headerView = delegate?.tableView?(tableView, viewForHeaderInSection: section) {
//                let headerHeight = delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? tableView.sectionHeaderHeight
//                headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)
//                headerView.layoutIfNeeded()
//                context.cgContext.saveGState()
//                context.cgContext.translateBy(x: 0, y: currentY)
//                headerView.layer.render(in: context.cgContext)
//                context.cgContext.restoreGState()
//                currentY += headerHeight
//            }
//            
//            // Draw cells
//            let numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: section)
//            for row in 0..<numberOfRows {
//                let indexPath = IndexPath(row: row, section: section)
//                if let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? UITableViewCell {
//                    let cellHeight = delegate?.tableView?(tableView, heightForRowAt: indexPath) ??
//                                     (tableView.rowHeight != UITableView.automaticDimension ? tableView.rowHeight : 44.0)
//                    cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: cellHeight)
//                    
//                    // Ensure cell is fully prepared
//                    cell.setNeedsLayout()
//                    cell.layoutIfNeeded()
//                    cell.contentView.setNeedsLayout()
//                    cell.contentView.layoutIfNeeded()
//                    
//                    // Debug: Print cell info
//                    print("Rendering cell at \(indexPath) with frame: \(cell.frame), content: \(cell.contentView.subviews)")
//                    
//                    // Render with context translation
//                    context.cgContext.saveGState()
//                    context.cgContext.translateBy(x: 0, y: currentY)
//                    cell.layer.render(in: context.cgContext)
//                    context.cgContext.restoreGState()
//                    currentY += cellHeight
//                }
//            }
//            
//            // Draw section footer
//            if let footerView = delegate?.tableView?(tableView, viewForFooterInSection: section) {
//                let footerHeight = delegate?.tableView?(tableView, heightForFooterInSection: section) ?? tableView.sectionFooterHeight
//                footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerHeight)
//                footerView.layoutIfNeeded()
//                context.cgContext.saveGState()
//                context.cgContext.translateBy(x: 0, y: currentY)
//                footerView.layer.render(in: context.cgContext)
//                context.cgContext.restoreGState()
//                currentY += footerHeight
//            }
//        }
//        
//        // Draw table footer
//        if let footer = tableView.tableFooterView {
//            footer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footer.frame.height)
//            footer.layoutIfNeeded()
//            context.cgContext.saveGState()
//            context.cgContext.translateBy(x: 0, y: currentY)
//            footer.layer.render(in: context.cgContext)
//            context.cgContext.restoreGState()
//        }
//    }
//    
//    return image
//}
