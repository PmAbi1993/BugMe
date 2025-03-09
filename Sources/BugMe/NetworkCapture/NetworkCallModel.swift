//
//  NetworkCallModel.swift
//  BugMe
//
//  Created by BugMe
//

import Foundation

/// Model representing a captured network call
public struct NetworkCallModel: Identifiable, Equatable, Hashable {
    public let id = UUID()
    public let timestamp: Date
    public let taskType: String
    
    // Request details
    public let url: URL?
    public let method: String?
    public let requestHeaders: [String: Any]?
    public let requestBody: Data?
    
    // Response details
    public let statusCode: Int?
    public let responseHeaders: [String: Any]?
    public let responseBody: Data?
    
    // Error details
    public let error: Error?
    
    public init(
        timestamp: Date = Date(),
        taskType: String,
        url: URL?,
        method: String?,
        requestHeaders: [String: Any]?,
        requestBody: Data?,
        statusCode: Int?,
        responseHeaders: [String: Any]?,
        responseBody: Data?,
        error: Error?
    ) {
        self.timestamp = timestamp
        self.taskType = taskType
        self.url = url
        self.method = method
        self.requestHeaders = requestHeaders
        self.requestBody = requestBody
        self.statusCode = statusCode
        self.responseHeaders = responseHeaders
        self.responseBody = responseBody
        self.error = error
    }
    
    // Provide convenience accessors for common data formats
    
    /// Get request body as a string if possible
    public var requestBodyString: String? {
        guard let data = requestBody else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Get response body as a string if possible
    public var responseBodyString: String? {
        guard let data = responseBody else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Get error description if available
    public var errorDescription: String? {
        error?.localizedDescription
    }
    
    // Conform to Equatable
    public static func == (lhs: NetworkCallModel, rhs: NetworkCallModel) -> Bool {
        lhs.id == rhs.id
    }
    
    // Conform to Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Returns a string representation of the network call suitable for logging
    public func logDescription() -> String {
        var log = "\n===== BugMe: Network Call Captured =====\n"
        log += "Task Type: \(taskType)\n"
        
        // Log Request
        log += "\n--- Request ---\n"
        log += "URL: \(url?.absoluteString ?? "N/A")\n"
        log += "Method: \(method ?? "N/A")\n"
        if let requestHeaders = requestHeaders,
           JSONSerialization.isValidJSONObject(requestHeaders),
           let jsonHeaders = try? JSONSerialization.data(withJSONObject: requestHeaders),
           let jsonData = String(data: jsonHeaders, encoding: .utf8) {
            log += "Headers: \(jsonData)\n"
        } else {
            log += "Headers: \(requestHeaders?.description ?? "N/A")\n"
        }
        if let bodyString = requestBodyString {
            log += "Body: \(bodyString)\n"
        }
        
        // Log Response
        log += "\n--- Response ---\n"
        if let statusCode = statusCode {
            log += "Status Code: \(statusCode)\n"
            log += "Headers: \(responseHeaders?.description ?? "N/A")\n"
        } else {
            log += "Status Code: N/A\n"
        }
        
        // Log Response Data
        if let bodyString = responseBodyString {
            log += "\nResponse Body: \(bodyString)\n"
        } else {
            log += "\nResponse Body: N/A\n"
        }
        
        // Log Error
        if let errorDesc = errorDescription {
            log += "\nError: \(errorDesc)\n"
        }
        
        log += "========================================\n"
        return log
    }
}

