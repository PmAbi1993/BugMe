//
//  HTMLExport.swift
//  BugMe
//
//  Created by Abhijith Pm on 9/3/25.
//

import Foundation
import UIKit
import OSLog

/// Class to generate an HTML report of all captured network calls and UI elements
public class HTMLExport {
    
    /// Generate and open a report with all captured UI elements and network calls
    /// This is a convenience method to generate and open the report in one step
    /// - Returns: URL where the HTML report was saved
    @MainActor
    public static func generateAndOpenReport() throws -> URL {
        let exporter = HTMLExport()
        let reportURL = try exporter.generateReport()
        
        // Log the report URL for reference
        osLog("HTML Report generated at: \(reportURL.path)")
        return reportURL
    }
    
    /// Get all controller names that have captured elements
    /// - Returns: Array of controller names with elements
    private func getControllersWithElements() -> [String] {
        // This is a workaround since we can't access capturedElements directly
        // We'll use a custom logging approach to collect controller names
        var controllers: [String] = []
        
        // We can utilize existing functionality in BMElementManager
        // such as iterating through some known controller names or checking ones we've observed
        
        // Check a list of potential controllers
        // This is not ideal but works as a fallback
        let potentialControllers = getAllViewControllerNames()
        
        for controller in potentialControllers {
            let elements = BMElementManager.shared.getElements(forController: controller)
            if !elements.isEmpty {
                controllers.append(controller)
            }
        }
        
        return controllers
    }
    
    /// Get all possible view controller names in the application
    /// This is a utility method to help discover controllers with elements
    /// - Returns: Array of controller class names
    private func getAllViewControllerNames() -> [String] {
        // In a real application, we might get these from a registry or similar
        // For now, we'll use a list of known controller names that might have elements
        
        // This is a temporary solution - ideally the BMElementManager would provide a way to
        // get all controller names or all elements directly
        
        // Get all controller names by checking if BMElementManager has logged any element blocks
        // This is a bit of a hack, but it works for now
        // We'll just use the controlled approach below
        
        // Instead, let's use reflection to find all controllers that have been recorded
        // Get controllers by trying a set of potential names (common patterns)
        var controllerNames: [String] = BMElementManager.shared.getAllElements().keys.map({ $0 })
        
        
        // Add potential controllers
        // In a real app, we might scan all classes or have a registry
        controllerNames.append("MainViewController")
        controllerNames.append("HomeViewController")
        controllerNames.append("LoginViewController")
        controllerNames.append("ProfileViewController")
        controllerNames.append("SettingsViewController")
        controllerNames.append("DetailViewController")
        controllerNames.append("TabBarController")
        
        // Since we can't check all possible controllers, check if any of these common ones have elements
        return controllerNames
    }
    
    /// CSS styles for the HTML report
    private let cssStyles = """
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f7;
        }

        .header {
            background: linear-gradient(135deg, #0a84ff, #0066cc);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }

        .header p {
            margin: 10px 0 0;
            opacity: 0.9;
        }

        .main-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #1d1d1f;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #0a84ff;
        }

        .component-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .component-item {
            background: #f8f8f8;
            border-radius: 8px;
            margin-bottom: 15px;
            overflow: hidden;
            display: flex;
            border-left: 4px solid #0a84ff;
        }

        .component-image {
            width: 200px;
            padding: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f0f0f0;
        }

        .component-image img {
            max-width: 100%;
            max-height: 200px;
            border-radius: 4px;
        }

        .component-content {
            flex: 1;
            padding: 20px;
            border-left: 1px solid #eee;
        }

        .component-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .component-name {
            font-size: 16px;
            font-weight: 600;
            color: #1d1d1f;
        }

        .network-status {
            display: inline-block;
            padding: 4px 8px;
            margin-left: 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-success {
            background: #e4f8ef;
            color: #1d6f42;
        }

        .status-error {
            background: #fde8e8;
            color: #c81e1e;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 14px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            text-align: left;
            padding: 12px;
            border-bottom: 1px solid #eee;
        }

        th {
            background: #f5f5f7;
            font-weight: 600;
            color: #666;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .footer {
            text-align: center;
            padding: 20px;
            color: #86868b;
            font-size: 14px;
        }
    </style>
    """
    
    /// Generate an HTML report of all captured UI elements and network calls
    /// - Returns: URL where the HTML report is saved
    @MainActor
    public func generateReport() throws -> URL {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        
        var html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>BugMe Debug Report</title>
            \(cssStyles)
        </head>
        <body>
            <div class="header">
                <h1>BugMe Debug Report</h1>
                <p>Generated on \(timestamp)</p>
            </div>
        """
        
        // First add UI Elements section
        html += generateUIElementsSection()
        
        // Then add Network Calls section
        html += generateNetworkCallsSection()
        
        // Add footer
        html += """
            <div class="footer">
                <p>Generated by BugMe Inspector</p>
            </div>
        </body>
        </html>
        """
        
        // Save HTML to file
        let reportData = Data(html.utf8)
        let reportName = "BugMeReport_\(Date().timeIntervalSince1970)"
        return try saveToDocuments(data: reportData, fileName: reportName, fileExtension: "html")
    }
    
    /// Generate the UI Elements section of the HTML report
    /// - Returns: HTML string for UI elements section
    @MainActor
    private func generateUIElementsSection() -> String {
        // Get all controller names with captured elements
        var allControllers: [String] = []
        var hasElements = false
        
        // We need to check if there are any controllers with elements
        // Since we can't access capturedElements directly, we'll use a different approach
        // by checking if any controller has elements
        let controllerNames = getControllersWithElements()
        
        guard !controllerNames.isEmpty else {
            return """
            <div class="main-section">
                <h2 class="section-title">📱 UI Elements</h2>
                <p>No UI elements captured.</p>
            </div>
            """
        }
        
        var html = """
        <div class="main-section">
            <h2 class="section-title">📱 UI Elements</h2>
        """
        
        // Process each controller's elements
        for controllerName in controllerNames {
            let elements = BMElementManager.shared.getElements(forController: controllerName)
            html += """
            <div class="controller-section">
                <h3>\(controllerName)</h3>
                <ul class="component-list">
            """
            
            // Process each element
            for element in elements {
                html += generateUIElementHTML(element)
            }
            
            html += """
                </ul>
            </div>
            """
        }
        
        html += "</div>"
        return html
    }
    
    /// Generate HTML for a single UI element
    /// - Parameter element: The UI element information
    /// - Returns: HTML string for the element
    private func generateUIElementHTML(_ element: BMElementInformation) -> String {
        // Save the element image if it exists
        var imagePath = ""
        if let image = element.image, let imageData = image.pngData() {
            do {
                let savedPath = try saveToDocuments(
                    data: imageData,
                    fileName: "element_\(element.elementName)_\(Date().timeIntervalSince1970)",
                    fileExtension: "png"
                )
                imagePath = savedPath.path
            } catch {
                print("Error saving element image: \(error)")
            }
        }
        
        var html = """
        <li class="component-item">
            <div class="component-image">
        """
        
        // Add image if available
        if !imagePath.isEmpty {
            html += """
                <img src="\(imagePath)" alt="\(element.elementName)">
            """
        } else {
            html += """
                <div style="width:100%;height:100px;display:flex;align-items:center;justify-content:center;color:#999;">
                    No Image
                </div>
            """
        }
        
        html += """
            </div>
            <div class="component-content">
                <div class="component-header">
                    <span class="component-name">\(element.elementType): \(element.elementName)</span>
                </div>
                <table>
        """
        
        // Add properties
        for property in element.properties {
            html += """
                    <tr>
                        <td>\(property.propertyName)</td>
                        <td>\(property.propertyValue)</td>
                    </tr>
            """
        }
        
        html += """
                </table>
            </div>
        </li>
        """
        
        return html
    }
    
    /// Generate the Network Calls section of the HTML report
    /// - Returns: HTML string for network calls section
    @MainActor
    private func generateNetworkCallsSection() -> String {
        let calls = NetworkCapture.shared.capturedCalls
        
        guard !calls.isEmpty else {
            return """
            <div class="main-section">
                <h2 class="section-title">🌐 Network Calls</h2>
                <p>No network calls captured.</p>
            </div>
            """
        }
        
        var html = """
        <div class="main-section">
            <h2 class="section-title">🌐 Network Calls</h2>
            <ul class="component-list">
        """
        
        // Process each network call
        for call in calls {
            html += generateNetworkCallHTML(call)
        }
        
        html += """
            </ul>
        </div>
        """
        
        return html
    }
    
    /// Generate HTML for a single network call
    /// - Parameter call: The network call model
    /// - Returns: HTML string for the network call
    private func generateNetworkCallHTML(_ call: NetworkCallModel) -> String {
        // Determine if call was successful
        let isSuccess = call.statusCode.map { $0 >= 200 && $0 < 300 } ?? false
        let statusClass = isSuccess ? "status-success" : "status-error"
        let statusText = call.statusCode.map { "\($0) \(httpStatusDescription(for: $0))" } ?? "No Status"
        
        let method = call.method ?? "Unknown"
        let endpoint = call.url?.lastPathComponent ?? "Unknown"
        
        var html = """
        <li class="component-item">
            <div class="component-content">
                <div class="component-header">
                    <span class="component-name">\(method) \(endpoint)</span>
        """
        
        if let statusCode = call.statusCode {
            html += """
                    <span class="network-status \(statusClass)">\(statusText)</span>
            """
        }
        
        html += """
                </div>
                <table>
                    <tr><td>URL</td><td>\(call.url?.absoluteString ?? "N/A")</td></tr>
                    <tr><td>Method</td><td>\(method)</td></tr>
                    <tr><td>Task Type</td><td>\(call.taskType)</td></tr>
                    <tr><td>Timestamp</td><td>\(DateFormatter.localizedString(from: call.timestamp, dateStyle: .medium, timeStyle: .medium))</td></tr>
        """
        
        // Request Headers
        if let headers = call.requestHeaders, !headers.isEmpty {
            html += """
                    <tr><td colspan="2"><strong>Request Headers</strong></td></tr>
            """
            
            for (key, value) in headers {
                html += """
                    <tr><td style="padding-left: 20px;">\(key)</td><td>\(value)</td></tr>
                """
            }
        }
        
        // Request Body
        if let requestBody = call.requestBodyString, !requestBody.isEmpty {
            html += """
                    <tr><td colspan="2"><strong>Request Body</strong></td></tr>
                    <tr><td colspan="2">
                        <pre style="margin: 0; white-space: pre-wrap;">\(formatJSON(requestBody))</pre>
                    </td></tr>
            """
        }
        
        // Response Headers
        if let headers = call.responseHeaders, !headers.isEmpty {
            html += """
                    <tr><td colspan="2"><strong>Response Headers</strong></td></tr>
            """
            
            for (key, value) in headers {
                html += """
                    <tr><td style="padding-left: 20px;">\(key)</td><td>\(value)</td></tr>
                """
            }
        }
        
        // Response Body
        if let responseBody = call.responseBodyString, !responseBody.isEmpty {
            html += """
                    <tr><td colspan="2"><strong>Response Body</strong></td></tr>
                    <tr><td colspan="2">
                        <pre style="margin: 0; white-space: pre-wrap;">\(formatJSON(responseBody))</pre>
                    </td></tr>
            """
        }
        
        // Error
        if let error = call.errorDescription {
            html += """
                    <tr><td colspan="2"><strong>Error</strong></td></tr>
                    <tr><td colspan="2" style="color: #c81e1e;">
                        <pre style="margin: 0; white-space: pre-wrap;">\(error)</pre>
                    </td></tr>
            """
        }
        
        html += """
                </table>
            </div>
        </li>
        """
        
        return html
    }
    
    /// Format JSON string for better readability
    /// - Parameter jsonString: The raw JSON string
    /// - Returns: Formatted JSON string if possible, otherwise original string
    private func formatJSON(_ jsonString: String) -> String {
        guard let data = jsonString.data(using: .utf8) else {
            return jsonString
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                return prettyString
            }
        } catch {
            // If it's not valid JSON, return original string
        }
        
        return jsonString
    }
    
    /// Get HTTP status code description
    /// - Parameter statusCode: The HTTP status code
    /// - Returns: Description of the status code
    private func httpStatusDescription(for statusCode: Int) -> String {
        switch statusCode {
        case 200: return "OK"
        case 201: return "Created"
        case 204: return "No Content"
        case 400: return "Bad Request"
        case 401: return "Unauthorized"
        case 403: return "Forbidden"
        case 404: return "Not Found"
        case 500: return "Internal Server Error"
        default:
            if statusCode >= 200 && statusCode < 300 {
                return "Success"
            } else if statusCode >= 400 && statusCode < 500 {
                return "Client Error"
            } else if statusCode >= 500 {
                return "Server Error"
            }
            return "Unknown"
        }
    }
}
