import UIKit

class CollectionViewDetailCapture {
    let collectionView: UICollectionView
    let title: String
    
    init(collectionView: UICollectionView, title: String?) {
        self.collectionView = collectionView
        self.title = title ?? "Unknown CollectionView"
    }
    
    @MainActor
    func getCollectionViewDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Collection properties
        properties.append(BMBlockItemProperties(key: "Number of Sections", value: "\(collectionView.numberOfSections)"))
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            properties.append(BMBlockItemProperties(key: "Minimum Line Spacing", value: "\(layout.minimumLineSpacing)"))
            properties.append(BMBlockItemProperties(key: "Minimum Interitem Spacing", value: "\(layout.minimumInteritemSpacing)"))
            properties.append(BMBlockItemProperties(key: "Item Size", value: "\(layout.itemSize)"))
            properties.append(BMBlockItemProperties(key: "Section Inset", value: "\(layout.sectionInset)"))
            properties.append(BMBlockItemProperties(key: "Header Size", value: "\(layout.headerReferenceSize)"))
            properties.append(BMBlockItemProperties(key: "Footer Size", value: "\(layout.footerReferenceSize)"))
            properties.append(BMBlockItemProperties(key: "Scroll Direction", value: "\(layout.scrollDirection.rawValue)"))
        }
        
        // Selection properties
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            properties.append(BMBlockItemProperties(key: "Selected Items", value: "\(selectedItems)"))
        }
        properties.append(BMBlockItemProperties(key: "Allows Selection", value: "\(collectionView.allowsSelection)"))
        properties.append(BMBlockItemProperties(key: "Allows Multiple Selection", value: "\(collectionView.allowsMultipleSelection)"))
        
        // Scroll properties
        properties.append(BMBlockItemProperties(key: "Content Size", value: "\(collectionView.contentSize)"))
        properties.append(BMBlockItemProperties(key: "Content Offset", value: "\(collectionView.contentOffset)"))
        properties.append(BMBlockItemProperties(key: "Content Inset", value: "\(collectionView.contentInset)"))
        properties.append(BMBlockItemProperties(key: "Shows Vertical Scroll Indicator", value: "\(collectionView.showsVerticalScrollIndicator)"))
        properties.append(BMBlockItemProperties(key: "Shows Horizontal Scroll Indicator", value: "\(collectionView.showsHorizontalScrollIndicator)"))
        properties.append(BMBlockItemProperties(key: "Bounces", value: "\(collectionView.bounces)"))
        properties.append(BMBlockItemProperties(key: "Always Bounces Vertical", value: "\(collectionView.alwaysBounceVertical)"))
        properties.append(BMBlockItemProperties(key: "Always Bounces Horizontal", value: "\(collectionView.alwaysBounceHorizontal)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(collectionView.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(collectionView.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(collectionView.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(collectionView.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(collectionView.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(collectionView.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(collectionView.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(collectionView.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(collectionView.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(collectionView.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(collectionView.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(collectionView.layer.shadowRadius)"))
        
        let imagePath: String? = try? collectionView.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
