//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 10/3/25.
//

import Foundation

class ViewBlockBuilder: HTMLContent {
    let viewBlock: BMBlock
    
    init(viewBlock: BMBlock) {
        self.viewBlock = viewBlock
    }
    
    func html() -> String {
        // Build the list of view element items
        let elementsHTML = buildElementsHTML()
        
        return """
        <h2 class="section-title">🖼️ View Elements</h2>
        <ul class="component-list">
            \(elementsHTML)
        </ul>
        """
    }
    
    private func buildElementsHTML() -> String {
        var elementsHTML = ""
        
        // If no elements, return empty block
        if viewBlock.elements.isEmpty {
            return "<li class=\"component-item\"><div class=\"component-content\">No view elements found.</div></li>"
        }
        
        // Add the controller as the main block
        elementsHTML += """
        <li class="component-item">
            <div class="component-content" style="display: flex;">
                <!-- Image on the left -->
                <div style="flex: 1; padding-right: 20px;">
                    <img src="\(viewBlock.imagePath ?? "https://via.placeholder.com/400x300")" alt="View Element Preview" style="max-width: 100%; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                </div>
                
                <!-- Table on the right -->
                <div style="flex: 1;">
                    <div class="component-header">
                        <span class="component-name">\(viewBlock.controller)</span>
                    </div>
                    <table>
                        <tr><td>Element Type</td><td>UIViewController</td></tr>
                        <tr><td>Identifier</td><td>\(viewBlock.controller.lowercased().replacingOccurrences(of: " ", with: "-"))</td></tr>
                        \(buildPropertiesHTML())
                    </table>
                </div>
            </div>
        </li>
        """
        
        // Add child elements if any
        for element in viewBlock.elements {
            elementsHTML += """
            <li class="component-item">
                <div class="component-content" style="display: flex;">
                    <!-- Image on the left -->
                    <div style="flex: 1; padding-right: 20px;">
                        <img src="\(element.imagePath ?? "https://via.placeholder.com/400x300")" alt="View Element Preview" style="max-width: 100%; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    </div>
                    
                    <!-- Table on the right -->
                    <div style="flex: 1;">
                        <div class="component-header">
                            <span class="component-name">\(element.title)</span>
                        </div>
                        <table>
                            \(buildElementPropertiesHTML(element))
                        </table>
                    </div>
                </div>
            </li>
            """
        }
        
        return elementsHTML
    }
    
    private func buildPropertiesHTML() -> String {
        // Default properties for the controller
        return """
            <tr><td>Size</td><td>Full screen</td></tr>
            <tr><td>Position</td><td>x: 0, y: 0</td></tr>
            <tr><td>Child Elements</td><td>\(viewBlock.elements.count)</td></tr>
            <tr><td>Accessibility</td><td>Enabled</td></tr>
            <tr><td>Visibility</td><td>Visible</td></tr>
            <tr><td>Created At</td><td>\(formatCurrentDate())</td></tr>
            
            <!-- Properties -->
            <tr><td colspan="2"><strong>Properties</strong></td></tr>
            <tr><td style="padding-left: 20px;">Background Color</td><td>#FFFFFF</td></tr>
            <tr><td style="padding-left: 20px;">Alpha</td><td>1.0</td></tr>
            <tr><td style="padding-left: 20px;">User Interaction</td><td>Enabled</td></tr>
        """
    }
    
    private func buildElementPropertiesHTML(_ element: BMBlockItem) -> String {
        var propertiesHTML = ""
        
        // Add basic properties
        var hasType = false
        var hasId = false
        var hasSize = false
        var hasPosition = false
        
        // Process each property from the element
        for property in element.properties {
            // Handle special properties
            if property.key.lowercased() == "type" || property.key.lowercased() == "element type" {
                propertiesHTML += "<tr><td>Element Type</td><td>\(property.value)</td></tr>\n"
                hasType = true
            } else if property.key.lowercased() == "id" || property.key.lowercased() == "identifier" {
                propertiesHTML += "<tr><td>Identifier</td><td>\(property.value)</td></tr>\n"
                hasId = true
            } else if property.key.lowercased() == "size" {
                propertiesHTML += "<tr><td>Size</td><td>\(property.value)</td></tr>\n"
                hasSize = true
            } else if property.key.lowercased() == "position" || property.key.lowercased() == "frame" {
                propertiesHTML += "<tr><td>Position</td><td>\(property.value)</td></tr>\n"
                hasPosition = true
            } else {
                // Other properties will be added in the Properties section
                continue
            }
        }
        
        // Add default values for missing required properties
        if !hasType {
            propertiesHTML += "<tr><td>Element Type</td><td>Unknown</td></tr>\n"
        }
        if !hasId {
            propertiesHTML += "<tr><td>Identifier</td><td>Unknown</td></tr>\n"
        }
        if !hasSize {
            propertiesHTML += "<tr><td>Size</td><td>Unknown</td></tr>\n"
        }
        if !hasPosition {
            propertiesHTML += "<tr><td>Position</td><td>Unknown</td></tr>\n"
        }
        
        // Add properties section
        propertiesHTML += "<tr><td colspan=\"2\"><strong>Properties</strong></td></tr>\n"
        for property in element.properties {
            if property.key.lowercased() != "type" && property.key.lowercased() != "element type" &&
               property.key.lowercased() != "id" && property.key.lowercased() != "identifier" &&
               property.key.lowercased() != "size" && property.key.lowercased() != "position" &&
               property.key.lowercased() != "frame" {
                propertiesHTML += "<tr><td style=\"padding-left: 20px;\">\(property.key)</td><td>\(property.value)</td></tr>\n"
            }
        }
        
        return propertiesHTML
    }
    
    private func formatCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: Date())
    }
}
