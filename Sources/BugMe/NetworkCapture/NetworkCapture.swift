//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import Foundation

public protocol NetworkCaptureDelegate: AnyObject {
    func networkCaptured(call: NetworkCallModel)
}

public class NetworkCapture {
    
    // Singleton instance
    @MainActor public static let shared = NetworkCapture()
    
    // Flag to check if swizzling is enabled
    private var isEnabled = false
    
    // Collection of captured network calls
    @MainActor public private(set) var capturedCalls: [NetworkCallModel] = []
    
    // Maximum number of calls to store (0 means unlimited)
    @MainActor public var maxStoredCalls: Int = 100
    
    // Delegate for real-time notifications
    @MainActor public weak var delegate: NetworkCaptureDelegate?
    
    private init() {}
    
    // Enable network call capturing
    public func enable() {
        guard !isEnabled else { return }
        isEnabled = true
        swizzleURLSessionMethods()
    }
    
    // Disable network call capturing
    public func disable() {
        guard isEnabled else { return }
        isEnabled = false
        // Restore original implementations by swizzling again
        swizzleURLSessionMethods()
    }
    
    // Method to swizzle URLSession methods
    private func swizzleURLSessionMethods() {
        // Swizzle data task methods
        swizzleMethod(for: URLSession.self,
                      originalSelector: #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask),
                      swizzledSelector: #selector(URLSession.swizzled_dataTask(with:completionHandler:)))
        
        swizzleMethod(for: URLSession.self,
                      originalSelector: #selector(URLSession.dataTask(with:) as (URLSession) -> (URLRequest) -> URLSessionDataTask),
                      swizzledSelector: #selector(URLSession.swizzled_dataTask(with:)))
        
        swizzleMethod(for: URLSession.self,
                      originalSelector: #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URL, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask),
                      swizzledSelector: #selector(URLSession.swizzled_dataTaskWithURL(with:completionHandler:)))
        
        // Swizzle download task methods
        swizzleMethod(for: URLSession.self,
                      originalSelector: #selector(URLSession.downloadTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask),
                      swizzledSelector: #selector(URLSession.swizzled_downloadTask(with:completionHandler:)))
        
        // Swizzle upload task methods
        swizzleMethod(for: URLSession.self,
                      originalSelector: #selector(URLSession.uploadTask(with:from:completionHandler:) as (URLSession) -> (URLRequest, Data, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask),
                      swizzledSelector: #selector(URLSession.swizzled_uploadTask(with:from:completionHandler:)))
    }
    
    // Generic method swizzling function
    private func swizzleMethod(for cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
              let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else {
            return
        }
        
        // If the method doesn't exist, add it. Otherwise, exchange implementations
        if class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    // Clear all stored calls
    @MainActor public func clearCapturedCalls() {
        capturedCalls.removeAll()
    }
    
    // Log request and response details
    static func logNetworkCall(request: URLRequest?, response: URLResponse?, data: Data?, error: Error?, taskType: String) {
        let model = NetworkCallModel(
            taskType: taskType,
            url: request?.url,
            method: request?.httpMethod,
            requestHeaders: request?.allHTTPHeaderFields as? [String: Any],
            requestBody: request?.httpBody,
            statusCode: (response as? HTTPURLResponse)?.statusCode,
            responseHeaders: (response as? HTTPURLResponse)?.allHeaderFields as? [String: Any],
            responseBody: data,
            error: error
        )
        
        // Print to console for logging purposes
        osLog(model.logDescription())
        
        // Store the model and notify delegate
        Task { @MainActor in
            let shared = NetworkCapture.shared
            shared.capturedCalls.append(model)
            
            // Enforce maximum stored calls limit if needed
            if shared.maxStoredCalls > 0 && shared.capturedCalls.count > shared.maxStoredCalls {
                shared.capturedCalls = Array(shared.capturedCalls.suffix(shared.maxStoredCalls))
            }
            
            // Notify delegate if available
            shared.delegate?.networkCaptured(call: model)
        }
    }
}

// MARK: - URLSession Extension for Swizzled Methods
extension URLSession {
    
    // Swizzled data task with URLRequest and completion handler
    @objc func swizzled_dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = swizzled_dataTask(with: request) { data, response, error in
            NetworkCapture.logNetworkCall(request: request, response: response, data: data, error: error, taskType: "Data Task (Request with Completion)")
            completionHandler(data, response, error)
        }
        return task
    }
    
    // Swizzled data task with URLRequest
    @objc func swizzled_dataTask(with request: URLRequest) -> URLSessionDataTask {
        let task = swizzled_dataTask(with: request)
        
        // Log the initial request
        NetworkCapture.logNetworkCall(request: request, response: nil, data: nil, error: nil, taskType: "Data Task (Request Only)")
        
        return task
    }
    
    // Swizzled data task with URL and completion handler
    @objc func swizzled_dataTaskWithURL(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        let task = swizzled_dataTaskWithURL(with: url) { data, response, error in
            NetworkCapture.logNetworkCall(request: request, response: response, data: data, error: error, taskType: "Data Task (URL with Completion)")
            completionHandler(data, response, error)
        }
        return task
    }
    
    // Swizzled download task with URLRequest and completion handler
    @objc func swizzled_downloadTask(with request: URLRequest, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        let task = swizzled_downloadTask(with: request) { fileURL, response, error in
            NetworkCapture.logNetworkCall(request: request, response: response, data: nil, error: error, taskType: "Download Task")
            completionHandler(fileURL, response, error)
        }
        return task
    }
    
    // Swizzled upload task with URLRequest, Data, and completion handler
    @objc func swizzled_uploadTask(with request: URLRequest, from bodyData: Data, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        var mutableRequest = request
        mutableRequest.httpBody = bodyData
        
        let task = swizzled_uploadTask(with: request, from: bodyData) { data, response, error in
            NetworkCapture.logNetworkCall(request: mutableRequest, response: response, data: data, error: error, taskType: "Upload Task")
            completionHandler(data, response, error)
        }
        return task
    }
}
