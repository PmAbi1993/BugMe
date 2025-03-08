//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 8/3/25.
//

import OSLog

// TODO: Reformat to make no Of Parameters lesser
public func osLog(_ message: String,
                  subsystem: String = "Abi",
                  category: String = "General",
                  file: String = #file,
                  line: Int = #line) {
    if #available(iOS 14.0, *) {
        let logger: Logger = Logger(subsystem: subsystem, category: category)
        let formattedMessage: String = """
File: \(file)
Line: \(line)
Message:
\(message)
"""
        logger.info("\(formattedMessage)")
    } else {
        // Print the logs to console and print the logs to file
        // Add stack trace also if needed.
    }
}


