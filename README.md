<p align="center">
    <img src="wink.png" width="650 max-width="90%" alt="Wink" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.3-orange.svg" />
    <img src="https://img.shields.io/badge/package%20manager-compatible-brightgreen.svg" />
    <a href="http://makeapullrequest.com">
        <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square" alt="PRs Welcome" />
    </a>
    <a href="https://medium.com/@toupper">
        <img src="https://img.shields.io/badge/medium-@toupper-blue.svg" alt="Medium: @toupper" />
    </a>
</p>

Welcome to **Wink**! — A light reactive library written in Swift that makes easy the process of Face Expression Detection on IOS. It detects a default set of user face expressions using the TrueDepth camera of the iPhone, and notifies you on real time using Combine.

## Features

- [x] Most common face expressions detection out of the box
- [x] Reactively notifies the current set of  user expressions
- [x] Easily extendable to detect more face expressions
- [x] Easily fine-tunable to adjust the expressions acceptance coefficient
- [x] No need to deal or import other frameworks than Wink and Combine. Forget about the cumbersome ARKit

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Device with TrueDepth Camera

## Installation
#### Manually
Since Wink is implemented within two files, you can simply drag and drop the sources dolder into your Xcode project. If however you want to use a dependency manager, I encourage you to use SPM:


#### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Wink does support its use on iOS.

Once you have your Swift package set up, adding Wink as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/toupper/Wink.git", .upToNextMajor(from: "0.1.0"))
]
```

- GIven the easiness of the integration with SPM, I do not support Carthage or CocoaPods at the moment. If you however  need one of those, open an issue and I will take care of that.

## Usage example

###  Detecting Face Expressions

Wink performs the user face expressions detection within the ```FacialExpressionDetectorViewController``` class. This view controller will contain the camera view that analyzes the user face searching for their
expressions. Therefore, if you want to start detecting expressions, you have to add this view controller to your hyerarchy, for instance through view controller containment, that is, adding it as a child:

```swift
import Wink

let facialExpressionDetectorViewController = FacialExpressionDetectorViewController()
addChild(facialExpressionDetectorViewController)

view.addSubview(facialExpressionDetectorViewController.view)
facialExpressionDetectorViewController.didMove(toParent: self)
```

If you don't want the camera view to appear in your view, you can easily hide the view:

```swift
import Wink

facialExpressionDetectorViewController.view.isHidden = true
```

or change its position:

```swift
import Wink

private func adjustFacialExpressionView() {
  facialExpressionDetectorViewController.view.translatesAutoresizingMaskIntoConstraints = false
  facialExpressionDetectorViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
  facialExpressionDetectorViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
  facialExpressionDetectorViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
  facialExpressionDetectorViewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
}
```

In order to be notified of the User Face Expressions change, you should subscribe to the ```facialExpression``` publisher:

```swift
import Wink

private func adjustFacialExpressionView() {
  facialExpressionDetectorViewController.facialExpressionPublisher.sink(receiveValue: { expressions in
    DispatchQueue.main.async {
      // react to new face expressions
    }
  }).store(in: &cancellables)
}
```

That observable returns an array of  ```FacialExpression``` objects. You can detect the existance of an specific face expression by checking its equality with the statically declared values:

```swift
import Wink

private func adjustFacialExpressionView() {
  facialExpressionDetectorViewController.facialExpressionPublisher.sink(receiveValue: { expressions in
    DispatchQueue.main.async {
      if expression.first == FaceExpression.mouthSmileLeft {
        /// do something
      }
    }
  }).store(in: &cancellables)
}
```

### Advanced

#### Detect more expressions

Currently Wink detects by default the following Face Expressions:

```swift
public static let mouthSmileLeft = FacialExpression(rawValue: "mouthSmileLeft")
public static let mouthSmileRight = FacialExpression(rawValue: "mouthSmileRight")
public static let browInnerUp =  FacialExpression(rawValue: "browInnerUp")
public static let tongueOut =  FacialExpression(rawValue: "tongueOut")
public static let cheekPuff =  FacialExpression(rawValue: "cheekPuff")
public static let eyeBlinkLeft =  FacialExpression(rawValue: "eyeBlinkLeft")
public static let eyeBlinkRight =  FacialExpression(rawValue: "eyeBlinkRight")
public static let jawOpen =  FacialExpression(rawValue: "jawOpen")
```

If you want to detect another face expression, you can add it by appending a new ```FacialExpressionAnalyzer``` into the ```FacialExpressionDetectorViewController``` ```analyzers``` property.
You require three values to initialize that. Firstly a new Wink ```FaceExpression``` object with a ```rawValue``` to check for equality:

```swift

extension FacialExpression {
  static let eyeWideLeft = FacialExpression(rawValue: "eyeWideLeft")
}
```

Secondly, the face expression itself that will be dectected. Since Wink uses ARKit to detect expressions, you should pass a ```ARFaceAnchor.BlendShapeLocation``` declaring the expression to be detected. Take a look [here](https://developer.apple.com/documentation/arkit/arfaceanchor/blendshapelocation) for an exhaustive list of possibilities. 

Thirdly and optionally, we need the coefficient from 0 to 1 that defines the acceptable degree of the face expression accuracy. For instance, fo an open mouth, 0 would be totally closed and 1 totally open.

```swift
facialExpressionDetectorViewController.analyzers.append(FacialExpressionAnalyzer(facialExpression: FacialExpression.eyeWideLeft, blendShapeLocation: .eyeWideLeft, minimumValidCoefficient: 0.6))
```

#### Modify the default expressions

If you do not want to be notified of all the default face expressions changes, or you want to change their accuracy coefficient, you can set the ```analyzers``` property to your desired value:

```swift

// Notifies only when the left eye is blinked, with a minor acceptance coefficient
facialExpressionDetectorViewController.analyzers = [FacialExpressionAnalyzer(facialExpression: FacialExpression.eyeBlinkLeft, blendShapeLocation: .eyeBlinkLeft, minimumValidCoefficient: 0.3)]
```


## Contribute

I would love you for the contribution to **Wink**, check the ``LICENSE`` file for more info.

## Credits

Created and maintained with love by [César Vargas Casaseca](https://www.cesarvargas.es). You can follow me on Medium [@toupper](https://medium.com/@toupper) for project updates, releases and more stories.

## License

Wink is released under the MIT license. [See LICENSE](https://github.com/toupper/Wink/blob/master/LICENSE) for details.
