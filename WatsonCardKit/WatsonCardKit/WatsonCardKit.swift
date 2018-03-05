//
//  WatsonCardKit.swift
//  WatsonCardKit
//
//  Created by Justin Weisz on 3/2/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKit
import DroneCardKit

/// WatsonCardKit card descriptors
public struct WatsonCardKit {
    fileprivate init() {}
}

// MARK: - Action Cards

extension WatsonCardKit {
    /// Contains descriptors for Action cards
    public struct Action {
        fileprivate init() {}
    }
}

extension WatsonCardKit.Action {
    /// Contains descriptors for Action/Think cards
    public struct Think {
        fileprivate init() {}
    }
}

extension WatsonCardKit.Action.Think {
    public static let DetectObject = ActionCardDescriptor(
        name: "Detect an Object",
        subpath: "Think",
        inputs: [
            InputSlot(name: "Objects", descriptor: CardKit.Input.Text.TextString, isOptional: false),
            InputSlot(name: "Confidence", descriptor: CardKit.Input.Numeric.Real, isOptional: true),
            InputSlot(name: "Frequency", descriptor: CardKit.Input.Time.Periodicity, isOptional: false)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera),
            TokenSlot(name: "Telemetry", descriptor: DroneCardKit.Token.Telemetry),
            TokenSlot(name: "WatsonVisualRecognition", descriptor: WatsonCardKit.Token.VisualRecognition)
        ],
        yields: [
            Yield(type: WCKDetectedObject.self)
        ],
        yieldDescription: "Yields the object that was detected",
        ends: true,
        endsDescription: "Ends when one of the given objects was detected",
        assetCatalog: CardAssetCatalog(description: "Detects an object in the camera's field of view using Watson"))
}

// MARK: - Token Cards

extension WatsonCardKit {
    /// Contains descriptors for Token cards
    public struct Token {
        fileprivate init() {}
    }
}

extension WatsonCardKit.Token {
    public static let VisualRecognition = TokenCardDescriptor(
        name: "Watson Visual Recognition",
        subpath: "Watson",
        isConsumed: false,
        assetCatalog: CardAssetCatalog(description: "Watson Visual Recognition token"))
}
