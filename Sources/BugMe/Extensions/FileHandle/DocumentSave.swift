// Requirement
// Create a function that will save any data to the documents directory.
// The fileName and extenshion should be a parameter
// If file already exists, Save it as fileName+i.fileExtension. Increment i by one until the file does not exist.
// Return the path of the saved file

import Foundation

/// Saves data to the documents directory with unique filename
/// - Parameters:
///   - data: The data to save
///   - fileName: Base name for the file (without extension)
///   - fileExtension: Extension for the file (without the dot)
/// - Returns: URL path where the file was saved
/// - Throws: Error if unable to get documents directory or save the file
public func saveToDocuments(data: Data, fileName: String, fileExtension: String) throws -> URL {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        throw NSError(domain: "FileHandlingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to access documents directory"])
    }
    
    var fileURL = documentsDirectory.appendingPathComponent("\(fileName).\(fileExtension)")
    var counter = 1
    
    // Check if file exists and increment counter until we find a unique name
    while FileManager.default.fileExists(atPath: fileURL.path) {
        fileURL = documentsDirectory.appendingPathComponent("\(fileName)\(counter).\(fileExtension)")
        counter += 1
    }
    
    try data.write(to: fileURL)
    return fileURL
}

