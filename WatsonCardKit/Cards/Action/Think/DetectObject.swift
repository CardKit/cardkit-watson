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


// swiftlint:disable cyclomatic_complexity

import Foundation

import CardKitRuntime
import DroneCardKit

public class DetectObject: ExecutableAction {
    //swiftlint:ignore cyclomatic_complexity
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            return
        }
        
        guard let telemetry: TelemetryToken = self.token(named: "Telemetry") as? TelemetryToken else {
            return
        }
        
        guard let watsonVisualRecognition: WatsonVisualRecognitionToken = self.token(named: "WatsonVisualRecognition") as? WatsonVisualRecognitionToken else {
            return
        }
        
        guard let objects: String = self.value(forInput: "Objects") else {
            return
        }
        
        let confidence: Double? = self.optionalValue(forInput: "Confidence")
        let frequency: Double? = self.optionalValue(forInput: "Frequency")
        
        // assuming Objects is a comma-separated string, chop it up
        let objectList = objects.components(separatedBy: ",")
        
        // we don't end until we've found the object we're looking for
        var foundObject: Bool = false
        
        repeat {
            // loop with the requested frequency -- if frequency is not set
            // then we will loop as fast as we can
            let loopStartDate: Date = Date()
            var nextLoopStartDate: Date = loopStartDate
            
            if let frequency = frequency {
                nextLoopStartDate.addTimeInterval(frequency)
            }
            
            do {
                // take a picture & classify
                let detectedObjects = try self.takePhotoAndClassify(camera: camera, telemetry: telemetry, watsonVisualRecognition: watsonVisualRecognition, confidence: confidence)
                
                // did we get what we were looking for?
                for object in objectList {
                    for detectedObject in detectedObjects {
                        if object.lowercased() == detectedObject.objectName.lowercased() {
                            // yes!
                            foundObject = true
                            
                            // capture the detected object in our yields
                            self.store(detectedObject, forYieldIndex: 0)
                            break
                        }
                    }
                }
                
            } catch {
                self.error(error)
                
                if !isCancelled {
                    cancel()
                }
            }
            
            // was there an error? if so, cancel execution and stop looping immediately
            if self.errors.count > 0 {
                cancel()
                break
            }
            
            // otherwise sleep until next loop start date
            Thread.sleep(until: nextLoopStartDate)
        } while !foundObject
    }
    
    override public func cancel() {
        // nothing to cancel
    }
    
    fileprivate func takePhotoAndClassify(camera: CameraToken, telemetry: TelemetryToken, watsonVisualRecognition: WatsonVisualRecognitionToken, confidence: Double?) throws -> [WCKDetectedObject] {
        var photo: DCKPhoto?
        var detectedObjects: [WCKDetectedObject] = []
        
        // take a picture
        if !isCancelled {
            let options: Set<CameraPhotoOption> = [.aspectRatio(.aspect16x9)]
            photo = try camera.takePhoto(options: options)
            
            // add drone's current location
            if let currentLocation = telemetry.currentLocation, let currentAltitude = telemetry.currentAltitude {
                photo?.location = DCKCoordinate3D(coordinate: currentLocation, altitude: currentAltitude)
            }
        }
        
        // send it to Watson
        if let photo = photo, let lfsPath = photo.pathInLocalFileSystem, !isCancelled {
            detectedObjects = try watsonVisualRecognition.classify(imagePath: lfsPath, threshold: confidence)
        }
        
        return detectedObjects
    }
}

// MARK: - TimeoutQueue

//swiftlint:disable:next private_over_fileprivate
fileprivate class LimitedLifetimeQueue<T> {
    private var array: [T] = []
    private let accessQueue = DispatchQueue(label: "LimitedLifetimeQueueAccess", attributes: .concurrent)
    
    public var count: Int {
        var count = 0
        
        self.accessQueue.sync {
            count = self.array.count
        }
        
        return count
    }
    
    public func enqueue(newElement: T, withLifetime lifetime: TimeInterval) {
        self.accessQueue.async(flags: .barrier) {
            self.array.append(newElement)
        }
    }
    
    public func dequeue() -> T? {
        var element: T?
        
        self.accessQueue.async(flags: .barrier) {
            element = self.array.remove(at: 0)
        }
        
        return element
    }
}
