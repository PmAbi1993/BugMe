//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 10/3/25.
//

import Foundation

class HTMLHeader: HTMLContent {
    let title: String
    let timestamp: Date
    let dateFormatter: DateFormatter
    
    init(title: String, timestamp: Date = Date()) {
        self.title = title
        self.timestamp = timestamp
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yy, h:mm:ss a"
    }
    
    func html() -> String {
        let formattedDate = dateFormatter.string(from: timestamp)
        
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>\(title)</title>
            \(HTMLStyleSheet.customCSS())
        </head>
        <body>
            <div class="header">
                <h1>\(title)</h1>
                <p>Generated on \(formattedDate)</p>
            </div>
        """
    }
}
