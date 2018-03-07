# WatsonCardKit

WatsonCardKit includes card definitions and implementations of cards that enable Watson services in the [CardKit](https://github.com/CardKit/cardkit) framework.

WatsonCardKit is written in Swift 4 and supports macOS, iOS, and tvOS.

## Cards

All cards in `WatsonCardKit` are specified in `WatsonCardCatalog`.

### Action Cards

#### Think

- **DetectObject**: uses Watson Visual Recognition to detect whether an object is present in the given image

### Token Cards

- **WatsonVisualRecognition**: interface to the Watson Visual Recognition service

## Building

WatsonCardKit depends on [CardKit](https://github.com/CardKit/cardkit), the [CardKit Runtime](https://github.com/CardKit/cardkit-runtime), and the [DroneCardKit](https://github.com/CardKit/cardkit-drone) frameworks. We use Carthage to manage our dependencies. Run `carthage bootstrap` to build all of the dependencies before building the WatsonCardKit Xcode project.

> ⚠️ WatsonCardKit depends on DroneCardKit's `CameraToken` and `TelemetryToken` definitions. In theory, WatsonCardKit could be made useful outside of the context of drones by defining its own Camera token.

> You will need a Watson Visual Recognition API key to run the tests. It is stored in `WatsonCardKitTests/ApiKeys.swift`.

## Known Limitations

Only the `DetectObject` card has been defined. In the future, other cards could be defined for other Watson services.

## Contributing

If you would like to contribute to WatsonCardKit, we recommend forking the repository, making your changes, and submitting a pull request.
