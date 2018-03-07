/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


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
        assetCatalog: CardAssetCatalog(description: "Detects an object in the camera's field of view using Watson", cardImageName: "think-detect-object"))
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
        assetCatalog: CardAssetCatalog(description: "Watson Visual Recognition token", cardImageName: "think-detect"))
}
