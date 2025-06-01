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
    var header: HTMLHeader?
    var footer: HTMLFooter?
    var sections: [HTMLSection] = []
    
    init(contents: [[HTMLContent]], header: HTMLHeader? = nil, footer: HTMLFooter? = nil) {
        self.contents = contents
        self.header = header ?? HTMLHeader(title: "AppReport Mirror Inspector", timestamp: Date())
        self.footer = footer ?? HTMLFooter(generatorName: "AppReport Mirror Inspector")
    }
    // TODO: Remove this implementation if not used in the project.
    init(title: String, sections: [HTMLSection] = [], timestamp: Date = Date(), generatorName: String = "AppReport Mirror Inspector") {
        self.contents = []
        self.header = HTMLHeader(title: title, timestamp: timestamp)
        self.sections = sections
        self.footer = HTMLFooter(generatorName: generatorName)
    }
    
    func addSection(_ section: HTMLSection) {
        sections.append(section)
    }
    
    func setHeader(title: String, timestamp: Date = Date()) {
        self.header = HTMLHeader(title: title, timestamp: timestamp)
    }
    
    func setFooter(generatorName: String) {
        self.footer = HTMLFooter(generatorName: generatorName)
    }
    
    // TODO: Refactor this with proper logic.
    func generateFullHTML() -> String {
        var htmlParts: [String] = []

        if let header = header {
            htmlParts.append(header.html())
        }
        
        if !sections.isEmpty {
            // New implementation with sections
            let sectionsHTML = sections.map { $0.html() }.joined(separator: lineSeparator)
            htmlParts.append(sectionsHTML)
        } else if !contents.isEmpty {
            // Legacy support for original implementation
            let contentHTML = contents.map({ section in
                let sectionContent = section.map({ $0.html() }).joined(separator: lineSeparator)
                return sectionContent
            }).joined(separator: lineSeparator)
            htmlParts.append(contentHTML)
        }
        
        if let footer = footer {
            htmlParts.append(footer.html())
        }
        
        return htmlParts.joined(separator: lineSeparator)
    }
}
