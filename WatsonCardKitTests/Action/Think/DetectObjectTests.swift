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


import XCTest

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit
@testable import WatsonCardKit

class DetectObjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDetectObject() {
        // executable card
        let detectObject = DetectObject(with: WatsonCardKit.Action.Think.DetectObject.makeCard())
        
        // bind inputs & tokens
        let cameraToken = MockCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let telemetryToken = MockTelemetryToken(with: DroneCardKit.Token.Telemetry.makeCard())
        let watsonToken = WatsonVisualRecognitionToken(with: WatsonCardKit.Token.VisualRecognition.makeCard(), usingApiKey: ApiKeys.visualRecognitionAPIKey)
        
        let inputBindings: [String: Codable] = ["Objects": "workroom", "Confidence": 0.7, "Frequency": 5.0]
        let tokenBindings: [String: ExecutableToken] = ["Camera": cameraToken, "Telemetry": telemetryToken, "WatsonVisualRecognition": watsonToken]
        
        detectObject.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "testDetectObject expectation")
        
        DispatchQueue.global(qos: .default).async {
            detectObject.main()
            myExpectation.fulfill()
        }
        
        // wait for execution to finish in 5 seconds
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("testDetectObject error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(detectObject.errors.count == 0)
            detectObject.errors.forEach { XCTFail("\($0)") }
            XCTAssertTrue(detectObject.yieldData.count > 0)
            
            guard let first = detectObject.yieldData.first else {
                XCTFail("expected a yield to be produced")
                return
            }
            
            guard let foundObject: WCKDetectedObject = first.data.unboxedValue() else {
                XCTFail("expected a yield of type WCKDetectedObject")
                return
            }
            XCTAssertEqual(foundObject.objectName, "workroom")
            XCTAssertTrue(foundObject.confidence > 0.7)
        }
    }
    
    // swiftlint:disable:next function_body_length
    func testDetectObjectInDeck() {
        // token cards
        let cameraCard = DroneCardKit.Token.Camera.makeCard()
        let telemetryCard = DroneCardKit.Token.Telemetry.makeCard()
        let watsonCard = WatsonCardKit.Token.VisualRecognition.makeCard()
        
        // detectObjects card
        var detectObjects = WatsonCardKit.Action.Think.DetectObject.makeCard()
        
        // bind tokens
        do {
            detectObjects = try detectObjects <- ("Camera", cameraCard)
            detectObjects = try detectObjects <- ("Telemetry", telemetryCard)
            detectObjects = try detectObjects <- ("WatsonVisualRecognition", watsonCard)
        } catch let error {
            XCTFail("error binding token cards: \(error)")
        }
        
        // bind inputs
        do {
            let objects = try CardKit.Input.Text.TextString <- "workroom"
            let confidence = try CardKit.Input.Numeric.Real <- 0.7
            let frequency = try CardKit.Input.Time.Periodicity <- 5.0
            
            detectObjects = try detectObjects <- ("Objects", objects)
            detectObjects = try detectObjects <- ("Confidence", confidence)
            detectObjects = try detectObjects <- ("Frequency", frequency)
        } catch let error {
            XCTFail("error binding inputs: \(error)")
        }
        
        // timer card
        var timer = CardKit.Action.Trigger.Time.Timer.makeCard()
        
        // bind inputs
        do {
            let duration = try CardKit.Input.Time.Duration <- 20.0
            timer = try timer <- ("Duration", duration)
        } catch let error {
            XCTFail("error binding inputs: \(error)")
        }
        
        // set up the deck -- one hand with detectObjects and a 20 second timer
        let deck = ( detectObjects || timer )%
//        let deck = ( ( detectObjects )% )%
        
        // add tokens to the deck
        deck.add(cameraCard)
        deck.add(telemetryCard)
        deck.add(watsonCard)
        
        // set up the execution engine
        let engine = ExecutionEngine(with: deck)
        engine.registerDescriptorCatalog(WatsonCardCatalog())
        
        // create token instances
        let camera = MockCameraToken(with: cameraCard)
        let telemetry = MockTelemetryToken(with: telemetryCard)
        let watson = WatsonVisualRecognitionToken(with: watsonCard, usingApiKey: ApiKeys.visualRecognitionAPIKey)
        
        engine.setTokenInstance(camera, for: cameraCard)
        engine.setTokenInstance(telemetry, for: telemetryCard)
        engine.setTokenInstance(watson, for: watsonCard)
        
        // execute
        engine.execute({ (yields: [YieldData], error: ExecutionError?) in
            XCTAssertNil(error)
            
            XCTAssertTrue(yields.count == 1)
            
            var detectedObjects: [String: WCKDetectedObject] = [:]
            for yield in yields {
                guard let object: WCKDetectedObject = yield.data.unboxedValue() else {
                    XCTFail("expected a yield of type WCKDetectedObject")
                    return
                }
                
                detectedObjects[object.objectName] = object
            }
            
            XCTAssertNotNil(detectedObjects["workroom"], "expected to find a workroom")
            
            //swiftlint:disable:next force_unwrapping
            XCTAssertTrue(detectedObjects["workroom"]!.confidence > 0.7)
        })
    }
}
