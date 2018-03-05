//
//  WCKInputTypes.swift
//  WatsonCardKit
//
//  Created by Justin Weisz on 3/2/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

// MARK: WCKDetectedObject

public struct WCKDetectedObject: Codable {
    public let objectName: String
    public let confidence: Double
}

extension WCKDetectedObject: Equatable {
    public static func == (lhs: WCKDetectedObject, rhs: WCKDetectedObject) -> Bool {
        // it's the same object if the name matches, independent of confidence
        // e.g. ["cat", 0.7] === ["cat", 0.2] (because it's a cat!)
        return lhs.objectName == rhs.objectName
    }
}
