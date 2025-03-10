//
//  BugMeViewManager.swift
//  BugMe
//
//  Created by Abhijith Pm on 9/3/25.
//
import UIKit

struct BMBlock {
    let controller: String
    let imagePath: String?
    let elements: [BMBlockItem]
}

struct BMBlockItem {
    let imagePath: String?
    let title: String
    let properties: [BMBlockItemProperties]
}

struct BMBlockItemProperties {
    let key: String
    let value: String
}

@available(iOS 13.0, *)
class BugMeViewManager: @unchecked Sendable {
    static let shared = BugMeViewManager()
    var dashBoardData = [BMBlock]()
    
    var latestController: BMBlock? {
        dashBoardData.last
    }
    
    func addBlock(block: BMBlock) {
        dashBoardData.append(block)
    }
    
    func clearAllBlocks() {
        dashBoardData.removeAll()
    }
    @MainActor
    func generateReport() {
        let viewElements = BugMeViewManager.shared.dashBoardData.map({ ViewBlockBuilder(viewBlock: $0) })
        let networkdData = NetworkCapture.shared.capturedCalls.map({ NetworkBlockBuilder(networkCallModel: $0) })
        let builder: HTMLBuilder = HTMLBuilder(contents: [viewElements, networkdData])
        let html = builder.generateFullHTML()
        guard let htmlData = html.data(using: .utf8) else {
            return
        }
        let fileURL = try? saveToDocuments(data: htmlData, fileName: "Sam", fileExtension: "html")
        print(fileURL)
    }
}
