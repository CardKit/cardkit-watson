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
