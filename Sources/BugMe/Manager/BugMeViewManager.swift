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
    let isView: Bool
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
}
