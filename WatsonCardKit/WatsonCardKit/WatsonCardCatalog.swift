//
//  WatsonCardCatalog.swift
//  WatsonCardKit
//
//  Created by Justin Weisz on 8/30/17.
//  Copyright © 2017 IBM. All rights reserved.
//

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
