<img src="http://danielozano.com/PresentrScreenshots/PresentrLogo.png" width="700">

[![Version](https://img.shields.io/cocoapods/v/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/cocoapods/p/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![License](https://img.shields.io/cocoapods/l/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![codebeat badge](https://codebeat.co/badges/f89d5cdf-b0c3-441d-b4e1-d56dcea48544)](https://codebeat.co/projects/github-com-icalialabs-presentr)

*Presentr is a simple wrapper for the Custom View Controller Presentation API introduced in iOS 8.*

## About

It is very common in an app to want to modally present a view on top of the current screen without covering it completely. It can be for presenting an alert, a menu, or any kind of popup with some other functionality.

Before iOS 8 this was done by adding a subiew on top of your content, but that is not the recommended way since a modal should ideally have its own view controller for handling all of the logic. View controller containment was also used, and was a better alternative, but still not ideal for this use case.

iOS 8 fixed all of this by introducing Custom View Controller Presentations, which allowed us to modally present view controllers in new ways. But in order to use this API it is up to us to implement a couple of classes and delegates that could be confusing for some.

**Presentr** is made to simplify this process by hiding all of that and providing a couple of custom presentations and transitions that I think you will find useful. If you want to contribute and add more presentations or transitions please send me a pull request!

## What's New

#### 1.0.1
- Added keyboard observation options for .popup (thanks @aasatt)
- Swipe to dismiss gesture (thanks @josejuanqm)

#### See CHANGELOG.md for previous

## Contributing

1. Fork project
2. Checkout **Develop** branch
3. Create **Feature** branch off of the **Develop** branch
4. Create awesome feature/enhancement/bug-fix
5. Optionally create *Issue* to discuss feature
6. Submit pull request from your **Feature** branch to Presentr’s **Develop** branch

## Supported Swift Versions

| Presentr Version   |      Swift Version      |    Min. iOS Version      |
|----------|:-------------:|:-------------:|
| <= 0.1.8 |  Swift 2.2  | >= iOS 8.0  |
| == 0.2.1 |    Swift 2.3 | >= iOS 8.0 |
| >= 1.0.0 | Swift 3.0 | >= iOS 9.0 |

## Installation

### [Cocoapods](http://cocoapods.org)

```ruby
use_frameworks!

pod 'Presentr'
```

### [Carthage](https://github.com/Carthage/Carthage)
Add Presentr to you `Cartfile`
```sh
github "IcaliaLabs/Presentr"
```
Install using
```sh
carthage update --platform ios
```


### Manually
1. Download and drop ```/Presentr``` folder in your project.  
2. You're done!

## Main Types

### Presentation Type

```swift
public enum PresentationType {
  case alert
  case popup
  case topHalf
  case bottomHalf
  case fullScreen
  case custom(width: ModalSize, height: ModalSize, center: ModalCenterPosition)
}
```
#### Alert & Popup
<img src="http://danielozano.com/PresentrScreenshots/Alert1.png" width="250">
<img src="http://danielozano.com/PresentrScreenshots/Popup1.png" width="250">
#### BottomHalf & TopHalf
<img src="http://danielozano.com/PresentrScreenshots/BottomHalf1.png" width="250">
<img src="http://danielozano.com/PresentrScreenshots/TopHalf2.png" width="250">

### Transition Type

```swift
public enum TransitionType{
  // System provided
  case coverVertical
  case crossDissolve
  case flipHorizontal
  // Custom
  case coverVerticalFromTop
  case coverHorizontalFromRight
  case coverHorizontalFromLeft
}
```

## Getting Started

### Create a Presentr object

It is **important to hold on to the Presentr object as a property** on the presenting/current View Controller since internally it will be used as a delegate for the custom presentation, so you must hold a strong reference to it.

```swift
class ViewController: UIViewController{

  let presenter: Presentr = {
      let presenter = Presentr(presentationType: .Alert)
      presenter.transitionType = .coverHorizontalFromRight // Optional
      return presenter
  }()

}
```

The PresentationType (and all other properties) can be changed later on in order to reuse the Presentr object for other presentations.

```swift
presenter.presentationType = .popup
```

### Properties
#### Properties are optional, as they all have Default values.

You can choose a TransitionType, which is the animation that will be used to present or dismiss the view controller.

```swift
presenter.transitionType = .coverVerticalFromTop
presenter.dismissTransitionType = .coverVertical
```

You can change the background color & opacity for the background view that will be displayed below the presented view controller. Default is black with 0.7 opacity.

```swift
presenter.backgroundColor = UIColor.red
presenter.backgroundOpacity = 1.0
```

You could also turn on the blur effect for the background, and change it's style. Default is false for the blur effect, and .Dark for the style. If you turn on the blur effect the background color and opacity will be ignored.

```swift
presenter.blurBackground = true
presenter.blurStyle = UIBlurEffectStyle.light
```

You can choose to disable rounded corners on the view controller that will be presented. Default is true.

```swift
presenter.roundCorners = false
```

You can choose to disable dismissOnTap that dismisses the presented view controller on tapping the background. Default is true. Or you can disable the animation for the dismissOnTap.

```swift
presenter.dismissOnTap = false
presenter.dismissAnimated = false
```

### Present the view controller.

Instantiate the View Controller you want to present. Remember to setup autolayout on it so it can be displayed well on any size.

```swift
let controller = SomeViewController()
customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
```

This is a helper method provided for you as an extension on UIViewController. It handles setting the Presentr object as the delegate for the presentation & transition.

### Creating a custom PresentationType

If you need to present a controller in a way that is not handled by the 4 included presentation types you can create your own. You create a custom **PresentationType** using the **.Custom** case on the **PresentationType** enum.
```swift
let customType = PresentationType.custom(width: width, height: height, center: center)
```

It has three associated values for the width, height and center position of the presented controller. For setting them we use two other enums.

```Swift
// This is used to calculate either a width or height value.
public enum ModalSize {
  case default
  case half   
  case full      
  case custom(size: Float)
}

// This is used to calculate the center point position for the modal.
public enum ModalCenterPosition {
  case center     
  case topCenter  
  case bottomCenter
  case custom(centerPoint: CGPoint)  // Custom fixed center point.
  case customOrigin(origin: CGPoint) // Custom fixed origin point.
}
```

This allows us to use a fixed value when we want
```swift
let width = ModalSize.custom(size: 300) // Custom 300pt width
```

But also let Presentr handle the calculations when we want something more common.
```swift
let height = ModalSize.full // Whole screen height
```

We could also set a fixed position
```swift
let position = ModalCenterPosition.custom(centerPoint: CGPoint(x: 150, y: 150))  // Custom center point
```

Or let presentr calculate the position
```swift
let position = ModalCenterPosition.center // Center of the screen
```

So we can mix and match, and have the benefit of a custom **PresentationType** but still have *Presentr* calculating the values we don't want to do ourselves. The following code creates a *Presentr* object with a custom **PresentationType** which shows the alert in a small top banner.

```swift
class ViewController: UIViewController{

  let customPresenter: Presentr = {

    let width = ModalSize.full
    let height = ModalSize.custom(size: 150)
    let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))

    let customType = PresentationType.custom(width: width, height: height, center: center)

    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .coverVerticalFromTop
    customPresenter.roundCorners = false
    return customPresenter

  }()

}
```

<img src="http://danielozano.com/PresentrScreenshots/CustomPresentationType.png" width="250">

### Presentr also comes with a cool AlertViewController baked in if you want something different from Apple's. The API is very similar to Apple's alert controller.

```swift

  let title = "Are you sure?"
  let body = "There is no way to go back after you do this!"

  let controller = Presentr.alertViewController(title: title, body: body)

  let deleteAction = AlertAction(title: "Sure 🕶", style: .destructive) {
    print("Deleted!")
  }

  let okAction = AlertAction(title: "NO, sorry 🙄", style: .cancel){
    print("Ok!")
  }

  controller.addAction(deleteAction)
  controller.addAction(okAction)

  presenter.presentationType = .alert
  customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)

```

<img src="http://danielozano.com/PresentrScreenshots/Alert2.png" width="250">

## Requirements

* iOS 9.0+
* Xcode 8.0+
* Swift 3.0+

## Documentation

Read the [docs](http://danielozano.com/PresentrDocs/). Generated with [jazzy](https://github.com/realm/jazzy).

##  Author
[Daniel Lozano](http://danielozano.com) <br>

## Main Contributors
[Gabriel Peart](http://swiftification.org/)
<br><br>
Logo design by [Eduardo Higareda](http://eldelentes.mx)<br>
Alert design by [Noe Araujo](http://www.noearaujo.com)

## License
Presentr is released under the MIT license.  
See LICENSE for details.
