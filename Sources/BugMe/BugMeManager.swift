//
//  BugMeManager.swift
//  BugMe
//
//  Created by Abhijith Pm on 9/3/25.
//

import Foundation

@available(iOS 13.0, *)
class BugMeManager: @unchecked Sendable {
    @MainActor
    static let shared = BugMeManager()
    let viewManager: BugMeViewManager
    
    init(viewManager: BugMeViewManager = .shared) {
        self.viewManager = viewManager
    }
}
