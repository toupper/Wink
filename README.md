<p align="center">
    <img src="wink.png" width="650" alt="Wink" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.9%2B-orange.svg" alt="Swift 5.9+" />
    <img src="https://img.shields.io/badge/SPM-supported-brightgreen.svg" alt="Swift Package Manager" />
</p>

Wink is a lightweight reactive Swift library for face-expression detection on iOS. It uses the TrueDepth camera and publishes the current set of detected expressions in real time with Combine.

## Features

- Common face expressions detected out of the box
- Real-time updates via Combine
- Easy to extend with custom analyzers
- Tunable acceptance coefficients for each expression
- Small API surface on top of ARKit

## Requirements

- iOS 13.0+
- Swift 5.9+
- Device with a TrueDepth camera

## Installation

### Swift Package Manager

Add Wink to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/toupper/Wink.git", from: "1.0.0")
```

Wink is SPM-only. If you need another package manager, open an issue first.

## Usage

### Detect face expressions

```swift
import Wink

let detectorViewController = FacialExpressionDetectorViewController()
addChild(detectorViewController)
view.addSubview(detectorViewController.view)
detectorViewController.didMove(toParent: self)
```

Hide or reposition the camera view if you do not want it visible:

```swift
detectorViewController.view.isHidden = true
```

Subscribe to face-expression updates:

```swift
import Combine
import Wink

detectorViewController.facialExpressionPublisher
  .sink { expressions in
    DispatchQueue.main.async {
      // react to new expressions
    }
  }
  .store(in: &cancellables)
```

Check for specific expressions with the built-in values:

```swift
if expressions.contains(.mouthSmileLeft) {
  // do something
}
```

## Advanced

### Detect more expressions

Extend `FacialExpression` with your own value:

```swift
extension FacialExpression {
  static let eyeWideLeft = FacialExpression(rawValue: "eyeWideLeft")
}
```

Then add a matching analyzer:

```swift
detectorViewController.analyzers.append(
  FacialExpressionAnalyzer(
    facialExpression: .eyeWideLeft,
    blendShapeLocation: .eyeWideLeft,
    minimumValidCoefficient: 0.6
  )
)
```

### Override the default analyzers

```swift
detectorViewController.analyzers = [
  FacialExpressionAnalyzer(
    facialExpression: .eyeBlinkLeft,
    blendShapeLocation: .eyeBlinkLeft,
    minimumValidCoefficient: 0.3
  )
]
```

## License

Wink is released under the MIT license. See [LICENSE](LICENSE) for details.
