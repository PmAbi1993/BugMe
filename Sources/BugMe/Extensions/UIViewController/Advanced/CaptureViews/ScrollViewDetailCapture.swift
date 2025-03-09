import UIKit

class ScrollViewDetailCapture {
    let scrollView: UIScrollView
    let title: String
    
    init(scrollView: UIScrollView, title: String?) {
        self.scrollView = scrollView
        self.title = title ?? "Unknown ScrollView"
    }
    
    @MainActor
    func getScrollViewDetails() -> BMBlockItem {
        var properties = [BMBlockItemProperties]()
        
        // Scroll properties
        properties.append(BMBlockItemProperties(key: "Content Size", value: "\(scrollView.contentSize)"))
        properties.append(BMBlockItemProperties(key: "Content Offset", value: "\(scrollView.contentOffset)"))
        properties.append(BMBlockItemProperties(key: "Content Inset", value: "\(scrollView.contentInset)"))
        properties.append(BMBlockItemProperties(key: "Adjusts Content Inset", value: "\(scrollView.adjustedContentInset)"))
        
        // Scroll behavior
        properties.append(BMBlockItemProperties(key: "Is Scrolling", value: "\(scrollView.isDragging || scrollView.isTracking)"))
        properties.append(BMBlockItemProperties(key: "Is Decelerating", value: "\(scrollView.isDecelerating)"))
        properties.append(BMBlockItemProperties(key: "Bounces", value: "\(scrollView.bounces)"))
        properties.append(BMBlockItemProperties(key: "Always Bounces Vertical", value: "\(scrollView.alwaysBounceVertical)"))
        properties.append(BMBlockItemProperties(key: "Always Bounces Horizontal", value: "\(scrollView.alwaysBounceHorizontal)"))
        properties.append(BMBlockItemProperties(key: "Paging Enabled", value: "\(scrollView.isPagingEnabled)"))
        properties.append(BMBlockItemProperties(key: "Scroll Enabled", value: "\(scrollView.isScrollEnabled)"))
        properties.append(BMBlockItemProperties(key: "Shows Vertical Scroll Indicator", value: "\(scrollView.showsVerticalScrollIndicator)"))
        properties.append(BMBlockItemProperties(key: "Shows Horizontal Scroll Indicator", value: "\(scrollView.showsHorizontalScrollIndicator)"))
        
        // Zoom properties
        properties.append(BMBlockItemProperties(key: "Minimum Zoom Scale", value: "\(scrollView.minimumZoomScale)"))
        properties.append(BMBlockItemProperties(key: "Maximum Zoom Scale", value: "\(scrollView.maximumZoomScale)"))
        properties.append(BMBlockItemProperties(key: "Current Zoom Scale", value: "\(scrollView.zoomScale)"))
        properties.append(BMBlockItemProperties(key: "Bouncers Zoom", value: "\(scrollView.bouncesZoom)"))
        properties.append(BMBlockItemProperties(key: "Is Zooming", value: "\(scrollView.isZooming)"))
        properties.append(BMBlockItemProperties(key: "Is Zooming Bouncing", value: "\(scrollView.isZoomBouncing)"))
        
        // UIView properties
        properties.append(BMBlockItemProperties(key: "Background Color", value: "\(scrollView.backgroundColor ?? .clear)"))
        properties.append(BMBlockItemProperties(key: "Alpha", value: "\(scrollView.alpha)"))
        properties.append(BMBlockItemProperties(key: "Hidden", value: "\(scrollView.isHidden)"))
        properties.append(BMBlockItemProperties(key: "User Interaction Enabled", value: "\(scrollView.isUserInteractionEnabled)"))
        properties.append(BMBlockItemProperties(key: "Tag", value: "\(scrollView.tag)"))
        properties.append(BMBlockItemProperties(key: "Frame", value: "\(scrollView.frame)"))
        properties.append(BMBlockItemProperties(key: "Bounds", value: "\(scrollView.bounds)"))
        
        // Layer properties
        properties.append(BMBlockItemProperties(key: "Corner Radius", value: "\(scrollView.layer.cornerRadius)"))
        properties.append(BMBlockItemProperties(key: "Border Width", value: "\(scrollView.layer.borderWidth)"))
        properties.append(BMBlockItemProperties(key: "Border Color", value: "\(scrollView.layer.borderColor ?? CGColor(gray: 0, alpha: 0))"))
        properties.append(BMBlockItemProperties(key: "Shadow Opacity", value: "\(scrollView.layer.shadowOpacity)"))
        properties.append(BMBlockItemProperties(key: "Shadow Radius", value: "\(scrollView.layer.shadowRadius)"))
        
        let imagePath: String? = try? scrollView.takeScreenshot(fileName: title).filePath.absoluteString
        return BMBlockItem(
            imagePath: imagePath,
            title: title,
            properties: properties
        )
    }
}
