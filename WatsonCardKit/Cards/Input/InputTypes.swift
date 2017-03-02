//
//  InputTypes.swift
//  WatsonCardKit
//
//  Created by Justin Weisz on 3/2/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: WCKDetectedObject

public struct WCKDetectedObject {
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

extension WCKDetectedObject: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        self.objectName = try json.getString(at: "objectName")
        self.confidence = try json.getDouble(at: "confidence")
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "objectName": self.objectName.toJSON(),
            "confidence": self.confidence.toJSON()
            ])
    }
}
