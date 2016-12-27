<img src="http://danielozano.com/Presentr/Screenshots/PresentrLogo.png" width="700">

[![Version](https://img.shields.io/cocoapods/v/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/cocoapods/p/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![License](https://img.shields.io/cocoapods/l/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![codebeat badge](https://codebeat.co/badges/f89d5cdf-b0c3-441d-b4e1-d56dcea48544)](https://codebeat.co/projects/github-com-icalialabs-presentr)

*Presentr is a simple customizable wrapper for the Custom View Controller Presentation API introduced in iOS 8.*

## About

iOS let's you modally present any view controller, but if you want the presented view controller to not cover the whole screen or modify anything about its presentation or transition you have to use the Custom View Controller Presentation API's.

This can be cumbersome, specially if you do it multiple times in your app. **Presentr** simplifies all of this. You just have to configure **Presentr** depending on how you want you view controller to be presented, and the framework handles everything for you.

<img src="http://danielozano.com/Presentr/Gifs/AlertSlow.gif" width="192">
<img src="http://danielozano.com/Presentr/Gifs/PopupSlow.gif" width="192">
<img src="http://danielozano.com/Presentr/Gifs/TopHalfSlow.gif" width="192">
<img src="http://danielozano.com/Presentr/Gifs/OtherSlow.gif" width="192">

*These are just examples of an Alert UI presented in multiple ways. But, with Presentr you can present any custom View Controller you create in any of the Presentation types, or create your own custom one!*

## What's New

#### 1.0.5
- Support for animated blurred background (thanks to @fpg1503)

#### 1.0.4
- New ModalSize option with sideMargin value (thanks to @alediaz84)
- Example project fixes

#### 1.0.3
- Support for custom radius & drop shadow (thanks @falkobuttler)
- New fluid percentage option for ModalSize enum (thanks @mseijas)
- Example project and other general improvements (thanks @gabrielPeart)

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

## Getting started

### Create a Presentr object

It is **important to hold on to the Presentr object as a property** on the presenting/current View Controller since internally it will be used as a delegate for the custom presentation, so you must hold a strong reference to it.

```swift
class ViewController: UIViewController{

  let presenter: Presentr = {
      let presenter = Presentr(presentationType: .alert)
      presenter.transitionType = .coverHorizontalFromRight // Optional
      return presenter
  }()

}
```

### Present the view controller.

Instantiate the View Controller you want to present. Remember to setup autolayout on it so it can be displayed well on any size.

```swift
let controller = SomeViewController()
customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
```

This is a helper method provided for you as an extension on UIViewController. It handles setting the Presentr object as the delegate for the presentation & transition.

The PresentationType (and all other properties) can be changed later on in order to reuse the Presentr object for other presentations.

```swift
presenter.presentationType = .popup
```

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
<img src="http://danielozano.com/Presentr/Gifs/AlertSlow.gif" width="250">
<img src="http://danielozano.com/Presentr/Gifs/PopupSlow.gif" width="250">
#### BottomHalf & TopHalf
<img src="http://danielozano.com/Presentr/Gifs/BottomHalfSlow.gif" width="250">
<img src="http://danielozano.com/Presentr/Gifs/TopHalfSlow.gif" width="250">

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

## Properties
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

You can also set the cornerRadius if you set roundCorners to true.

```swift
presenter.cornerRadius = 10
```

Using the PresentrShadow struct can set a custom shadow on the presented view controller.

```swift
let shadow = PresentrShadow()
shadow.shadowColor = .black
shadow.shadowOpacity = 0.5
shadow.shadowOffset = CGSize(5,5)
shadow.shadowRadius = 4.0

presenter.dropShadow = shadow
```

You can choose to disable dismissOnTap that dismisses the presented view controller on tapping the background. Default is true. Or you can disable the animation for the dismissOnTap.

```swift
presenter.dismissOnTap = false
presenter.dismissAnimated = false
```

You can activate dismissOnSwipe so that swiping up inside the presented view controller dismisses it. Default is false. If your view controller uses any kind of scroll view this is not recommended as it will mess with the scrolling.

```swift
presenter.dismissOnSwipe = true
```

If you have text fields inside your modal, you can use a KeyboardTranslationType to tell Presentr how to handle your modal when the keyboard shows up.

```swift
presenter.keyboardTranslationType = .none
presenter.keyboardTranslationType = .moveUp
presenter.keyboardTranslationType = .compress
presenter.keyboardTranslationType = .stickToTop
```

## Delegate

You can conform to the PresentrDelegate protocol in your presented view controller if you want to get a callback. Using this method you can prevent the view controller from being dismissed when the background is tapped and/or perform something before it's dismissed.

```swift
func presentrShouldDismiss(keyboardShowing: Bool) -> Bool { }
```

## Creating a custom PresentationType

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
  case fluid(percentage: Float)
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

<img src="http://danielozano.com/Presentr/Screenshots/CustomPresentationType.png" width="250">

## AlertViewController

Presentr also comes with a cool AlertViewController baked in if you want something different from Apple's. The API is very similar to Apple's alert controller.

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

<img src="http://danielozano.com/Presentr/Screenshots/Alert2.png" width="250">

## Requirements

* iOS 9.0+
* Xcode 8.0+
* Swift 3.0+

## Documentation

Read the [docs](http://danielozano.com/Presentr/Docs/). Generated with [jazzy](https://github.com/realm/jazzy).

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
