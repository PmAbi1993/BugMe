import UIKit

class TableViewDetailCapture {
    let tableView: UITableView
    let title: String
    
    init(tableView: UITableView, title: String?) {
        self.tableView = tableView
        self.title = title ?? "Unknown TableView"
    }
    
    @MainActor
    func getTableViewDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Table properties
        properties.append(BMBlockItemProperties(key: "Style", value: "\(tableView.style.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Number of Sections", value: "\(tableView.numberOfSections)"))
        properties.append(BMBlockItemProperties(key: "Total Rows", value: "\(tableView.numberOfRows(inSection: 0))"))
        properties.append(BMBlockItemProperties(key: "Separator Style", value: "\(tableView.separatorStyle.rawValue)"))
        properties.append(BMBlockItemProperties(key: "Separator Color", value: "\(tableView.separatorColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Separator Inset", value: "\(tableView.separatorInset)"))
        
        // Selection properties
        if let selectedRows = tableView.indexPathsForSelectedRows {
            properties.append(BMBlockItemProperties(key: "Selected Rows", value: "\(selectedRows)"))
        }
        properties.append(BMBlockItemProperties(key: "Allows Selection", value: "\(tableView.allowsSelection)"))
        properties.append(BMBlockItemProperties(key: "Allows Multiple Selection", value: "\(tableView.allowsMultipleSelection)"))
        
        // Cell properties
        properties.append(BMBlockItemProperties(key: "Row Height", value: "\(tableView.rowHeight)"))
        properties.append(BMBlockItemProperties(key: "Section Header Height", value: "\(tableView.sectionHeaderHeight)"))
        properties.append(BMBlockItemProperties(key: "Section Footer Height", value: "\(tableView.sectionFooterHeight)"))
        properties.append(BMBlockItemProperties(key: "Estimated Row Height", value: "\(tableView.estimatedRowHeight)"))
        
        // Scroll properties
        properties.append(BMBlockItemProperties(key: "Content Size", value: "\(tableView.contentSize)"))
        properties.append(BMBlockItemProperties(key: "Content Offset", value: "\(tableView.contentOffset)"))
        properties.append(BMBlockItemProperties(key: "Content Inset", value: "\(tableView.contentInset)"))
        properties.append(BMBlockItemProperties(key: "Shows Vertical Scroll Indicator", value: "\(tableView.showsVerticalScrollIndicator)"))
        properties.append(BMBlockItemProperties(key: "Shows Horizontal Scroll Indicator", value: "\(tableView.showsHorizontalScrollIndicator)"))
        
        // Editing properties
        properties.append(BMBlockItemProperties(key: "Is Editing", value: "\(tableView.isEditing)"))
        properties.append(BMBlockItemProperties(key: "Allows Selection During Editing", value: "\(tableView.allowsSelectionDuringEditing)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(tableView.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(tableView.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(tableView.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(tableView.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(tableView.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(tableView.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(tableView.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(tableView.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(tableView.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(tableView.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(tableView.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(tableView.layer.shadowRadius)"))
        
        let imagePath: String? = try? tableView.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
