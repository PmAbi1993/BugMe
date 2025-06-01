//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 10/3/25.
//

import Foundation

class NetworkBlockBuilder: HTMLContent {
    let networkCallModel: NetworkCallModel
    
    init(networkCallModel: NetworkCallModel) {
        self.networkCallModel = networkCallModel
    }
    
    func html() -> String {
        // Generate a status class based on HTTP status code
        let statusClass = getStatusClass()
        // Generate a status text
        let statusText = getStatusText()
        
        return """
            <li class="component-item">
                <div class="component-content">
                    <div class="component-header">
                        <span class="component-name">\(networkCallModel.method ?? "UNKNOWN") \(networkCallModel.url?.path ?? "/")</span>
                        <span class="network-status \(statusClass)">\(statusText)</span>
                    </div>
                    <table>
                        <tr><td>URL</td><td>\(networkCallModel.url?.absoluteString ?? "N/A")</td></tr>
                        <tr><td>Method</td><td>\(networkCallModel.method ?? "N/A")</td></tr>
                        <tr><td>Duration</td><td>N/A</td></tr>
                        <tr><td>Timestamp</td><td>\(formatDate(networkCallModel.timestamp))</td></tr>
        
                        <!-- Request Headers -->
                        <tr><td colspan="2"><strong>Request Headers</strong></td></tr>
                        \(generateRequestHeadersHTML())
        
                        <!-- Request Body -->
                        <tr><td colspan="2"><strong>Request Body</strong></td></tr>
                        <tr><td colspan="2">
                            <pre style="margin: 0; white-space: pre-wrap;">
        \(formatBody(networkCallModel.requestBodyString))
                            </pre>
                        </td></tr>
        
                        <!-- Response Body -->
                        <tr><td colspan="2"><strong>Response Body</strong></td></tr>
                        <tr><td colspan="2">
                            <pre style="margin: 0; white-space: pre-wrap;">
        \(formatBody(networkCallModel.responseBodyString))
                            </pre>
                        </td></tr>
                    </table>
                </div>
            </li>
        """
    }
    
    // Helper functions to generate HTML components
    
    private func getStatusClass() -> String {
        guard let statusCode = networkCallModel.statusCode else {
            return "status-error"
        }
        
        return (200...299).contains(statusCode) ? "status-success" : "status-error"
    }
    
    private func getStatusText() -> String {
        guard let statusCode = networkCallModel.statusCode else {
            return networkCallModel.errorDescription ?? "ERROR"
        }
        
        let statusMessage: String
        switch statusCode {
        case 200: statusMessage = "OK"
        case 201: statusMessage = "Created"
        case 204: statusMessage = "No Content"
        case 400: statusMessage = "Bad Request"
        case 401: statusMessage = "Unauthorized"
        case 403: statusMessage = "Forbidden"
        case 404: statusMessage = "Not Found"
        case 500: statusMessage = "Internal Server Error"
        default: statusMessage = ""
        }
        
        return "\(statusCode) \(statusMessage)"
    }
    
    private func generateRequestHeadersHTML() -> String {
        guard let headers = networkCallModel.requestHeaders, !headers.isEmpty else {
            return "<tr><td style=\"padding-left: 20px;\">No headers</td><td></td></tr>"
        }
        
        var html = ""
        for (key, value) in headers {
            html += "<tr><td style=\"padding-left: 20px;\">\(key)</td><td>\(value)</td></tr>\n"
        }
        return html
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter.string(from: date)
    }
    
    private func formatBody(_ body: String?) -> String {
        guard let body = body else { return "No body content" }
        
        // Try to format JSON if it's valid JSON
        if let jsonData = body.data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
           let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let prettyPrintedString = String(data: prettyJsonData, encoding: .utf8) {
            return prettyPrintedString
        }
        
        return body
    }
}
