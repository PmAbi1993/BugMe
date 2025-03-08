//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import Foundation

public class NetworkCapture {
    
    // Singleton instance
    @MainActor public static let shared = NetworkCapture()
    
    // Flag to check if swizzling is enabled
    private var isEnabled = false
    
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
    
    // Log request and response details
    static func logNetworkCall(request: URLRequest?, response: URLResponse?, data: Data?, error: Error?, taskType: String) {
        print("\n===== BugMe: Network Call Captured =====")
        print("Task Type: \(taskType)")
        
        // Log Request
        if let request = request {
            print("\n--- Request ---")
            print("URL: \(request.url?.absoluteString ?? "N/A")")
            print("Method: \(request.httpMethod ?? "N/A")")
            print("Headers: \(request.allHTTPHeaderFields?.description ?? "N/A")")
            if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
                print("Body: \(bodyString)")
            }
        }
        
        // Log Response
        print("\n--- Response ---")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields.description)")
        } else {
            print("Status Code: N/A")
        }
        
        // Log Response Data
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("\nResponse Body: \(dataString)")
        } else {
            print("\nResponse Body: N/A")
        }
        
        // Log Error
        if let error = error {
            print("\nError: \(error.localizedDescription)")
        }
        
        print("========================================\n")
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
