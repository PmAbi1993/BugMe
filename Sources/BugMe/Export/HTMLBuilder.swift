//
//  File.swift
//  BugMe
//
//  Created by Abhijith Pm on 9/3/25.
//

import Foundation

protocol HTMLContent {
    func html() -> String
}

class HTMLBuilder: @unchecked Sendable {
    let contents: [[HTMLContent]]
    let lineSeparator: String = "\n"
    
    // TODO: Enhance HTMLBuilder to support:
//    1. Add custom Header
//    2. Add custom css
//    3. Add custom JavaScript
//    4. Add custom footer
    
    init(contents: [[HTMLContent]]) {
        self.contents = contents
    }
    
    func generateFullHTML() -> String {
        contents.map({ section in
            let sectionContent = section.map({ $0.html() }).joined(separator: lineSeparator)
            return sectionContent
        }).joined(separator: lineSeparator)
    }
}
