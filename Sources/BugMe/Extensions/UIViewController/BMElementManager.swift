//
//  BMElementManager.swift
//  BugMe
//
//  Created by Alex on behalf of Abhijith Pm
//

import Foundation
import OSLog

/// Manager class to store and handle capture elements
@available(iOS 13.0, *)
public class BMElementManager: @unchecked Sendable {
    /// Shared instance of BMElementManager
    public static let shared = BMElementManager()
    
    /// Dictionary to store controller name and its captured elements
    private var capturedElements: [String: [BMElementInformation]] = [:]
    
    private init() {}
    
    /// Add a captured element to the manager
    /// - Parameters:
    ///   - element: The captured element information
    ///   - controllerName: The name of the controller where the element was captured
    func addElement(_ element: BMElementInformation, forController controllerName: String) {
        if capturedElements[controllerName] == nil {
            capturedElements[controllerName] = []
        }
        capturedElements[controllerName]?.append(element)
    }
    
    /// Get all captured elements for a controller
    /// - Parameter controllerName: The name of the controller
    /// - Returns: Array of captured element information
    func getElements(forController controllerName: String) -> [BMElementInformation] {
        return capturedElements[controllerName] ?? []
    }
    
    /// Create a BMElementBlock from captured elements for a controller
    /// - Parameter controllerName: The name of the controller
    /// - Returns: BMElementBlock containing the controller name and captured elements
    func createElementBlock(forController controllerName: String) -> BMElementBlock? {
        guard let elements = capturedElements[controllerName], !elements.isEmpty else {
            return nil
        }
        
        return BMElementBlock(controller: controllerName, elements: elements)
    }
    
    /// Log the element block for a controller
    /// - Parameter controllerName: The name of the controller
    public func logElementBlock(forController controllerName: String) {
        guard let elementBlock = createElementBlock(forController: controllerName) else {
            osLog("No elements captured for controller: \(controllerName)")
            return
        }
        
        var logOutput = "Controller: \(elementBlock.controller)\n"
        logOutput += "Total Elements Captured: \(elementBlock.elements.count)\n"
        
        for (index, element) in elementBlock.elements.enumerated() {
            logOutput += "\n[\(index + 1)] \(element.formattedDescription())\n"
        }
        
        osLog(logOutput)
    }
    
    /// Clear captured elements for a controller
    /// - Parameter controllerName: The name of the controller to clear elements for
    public func clearElements(forController controllerName: String) {
        capturedElements[controllerName] = nil
    }
    
    /// Clear all captured elements
    public func clearAllElements() {
        capturedElements.removeAll()
    }
}
