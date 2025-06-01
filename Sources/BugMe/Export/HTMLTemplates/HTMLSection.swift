//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 10/3/25.
//

import Foundation

class HTMLSection: HTMLContent {
    let title: String
    let icon: String
    let contents: [HTMLContent]
    
    init(title: String, icon: String, contents: [HTMLContent]) {
        self.title = title
        self.icon = icon
        self.contents = contents
    }
    
    func html() -> String {
        let contentHTML = contents.map { $0.html() }.joined(separator: "\n")
        
        return """
        <div class="main-section">
            <h2 class="section-title">\(icon) \(title)</h2>
            <ul class="component-list">
                \(contentHTML)
            </ul>
        </div>
        """
    }
}
