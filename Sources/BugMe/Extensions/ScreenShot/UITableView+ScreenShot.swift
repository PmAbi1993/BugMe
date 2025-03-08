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
            // 5.1 & 5.2. Scroll to current section and capture section header
            if let sectionHeaderView = headerView(forSection: section) {
                scrollRectToVisible(sectionHeaderView.frame, animated: false)
                tableScreenShots.append(sectionHeaderView.takeScreenshot())
            }
            
            // 5.3. Scroll to each cell, take screenshot and store in tableScreenShots
            for row in 0..<numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                scrollToRow(at: indexPath, at: .top, animated: false)
                
                if let cell = cellForRow(at: indexPath) {
                    tableScreenShots.append(cell.takeScreenshot())
                }
            }
            
            // 5.4. Scroll to section footer, take a screenshot and insert it into tableScreenShots
            if let sectionFooterView = footerView(forSection: section) {
                scrollRectToVisible(sectionFooterView.frame, animated: false)
                tableScreenShots.append(sectionFooterView.takeScreenshot())
            }
        }
        
        // 6. Once the function exits loop, Scroll to UITableViewFooterView
        // 7. Take screenshot and insert it into tableScreenShots
        if let tableFooterView = tableFooterView {
            scrollRectToVisible(tableFooterView.frame, animated: false)
            tableScreenShots.append(tableFooterView.takeScreenshot())
        }
        
        // Restore the original scroll position
        setContentOffset(currentOffset, animated: false)
        
        return tableScreenShots
    }
}
