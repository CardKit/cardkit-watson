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
import CardKitRuntime

public struct WatsonCardCatalog: DescriptorCatalog {
    /// All card descriptors included in WatsonCardKit
    public let descriptors: [CardDescriptor] = [
        WatsonCardKit.Action.Think.DetectObject
    ]
    
    public var executableActionTypes: [ActionCardDescriptor: ExecutableAction.Type] = [
        WatsonCardKit.Action.Think.DetectObject: DetectObject.self
    ]
}
