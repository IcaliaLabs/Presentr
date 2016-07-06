<img src="http://danielozano.com/PresentrScreenshots/PresentrLogo.png" width="700">

[![Version](https://img.shields.io/cocoapods/v/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![Platform](https://img.shields.io/cocoapods/p/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![License](https://img.shields.io/cocoapods/l/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![codebeat badge](https://codebeat.co/badges/f89d5cdf-b0c3-441d-b4e1-d56dcea48544)](https://codebeat.co/projects/github-com-icalialabs-presentr)

*Presentr is a simple wrapper for the Custom View Controller Presentation API introduced in iOS 8.*

## About

It is very common in an app to want to modally present a view on top of the current screen without covering it completely. It can be for presenting an alert, a menu, or any kind of popup with some other functionality.

Before iOS 8 this was done by adding a subiew on top of your content, but that is not the recommended way since a modal should ideally have its own view controller for handling all of the logic. View controller containment was also used, and was a better alternative, but still not ideal for this use case.

iOS 8 fixed all of this by introducing Custom View Controller Presentations, which allowed us to modally present view controllers in new ways. But in order to use this API it is up to us to implement a couple of classes and delegates that could be confusing for some.

**Presentr** is made to simplify this process by hiding all of that and providing a couple of custom presentations and transitions that I think you will find useful. If you want to contribute and add more presentations or transitions please send me a pull request!

## Installation

#### [CocoaPods](http://cocoapods.org)

```ruby
use_frameworks!

pod 'Presentr'
```

#### Manually
1. Download and drop ```/Presentr``` folder in your project.  
2. Congratulations! 

## Usage

### Main Types

#### Presentation Type

```swift
public enum PresentationType {
  case Alert
  case Popup
  case TopHalf
  case BottomHalf
  case Custom(width: ModalSize, height: ModalSize, center: ModalCenterPosition)
}
```
##### Alert & Popup
<img src="http://danielozano.com/PresentrScreenshots/Alert1.png" width="250">
<img src="http://danielozano.com/PresentrScreenshots/Popup1.png" width="250">
##### BottomHalf & TopHalf
<img src="http://danielozano.com/PresentrScreenshots/BottomHalf1.png" width="250">
<img src="http://danielozano.com/PresentrScreenshots/TopHalf2.png" width="250">

#### Transition Type

```swift
public enum TransitionType{
  // System provided
  case CoverVertical
  case CrossDissolve
  case FlipHorizontal
  // Custom
  case CoverVerticalFromTop
  case CoverHorizontalFromRight
  case CoverHorizontalFromLeft
}
```

### Getting Started

#### Create a Presentr object

It is **important to hold on to the Presentr object as a property** on the presenting/current View Controller since internally it will be used as a delegate for the custom presentation, so you must hold a strong reference to it.

```swift
class ViewController: UIViewController{

  let presenter: Presentr = {
      let presenter = Presentr(presentationType: .Alert)
      presenter.transitionType = .CoverHorizontalFromRight // Optional
      return presenter
  }()

}
```

Both types can be changed later on in order to reuse the Presentr object for other presentations.

```swift
presenter.presentationType = .Popup
presenter.transitionType = .CoverVerticalFromTop
```

Now you can also choose to disable rounded corners on the view controller that will be presented. Default is true except for .TopHalf and .BottomHalf presentation types.

```swift
presenter.roundCorners = false
```

#### Present the view controller.

Instantiate the View Controller you want to present. Remember to setup autolayout on it so it can be displayed well on any size.

```swift
let controller = SomeViewController()
customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
```

This is a helper method provided for you as an extension on UIViewController. It handles setting the Presentr object as the delegate for the presentation & transition. 

#### Creating a custom PresentationType

If you need to present a controller in a way that is not handled by the 4 included presentation types you can create your own.

You create a custom PresentationType using the .Custom case on the PresentationType enum. 
```swift 
let customType = PresentationType.Custom(width: width, height: height, center: center)
```

It has three associated values for the width, height and center position of the presented controller. For setting them we use two other enums.

```Swift
// This is used to calculate either a width or height value.
public enum ModalSize {
  case Default   // Default modal size. Uses margins to calculate width or height. Used in the .Popup presentation type.
  case Half      // Half of the screen 
  case Full      // Whole screen
  case Custom(size: Float) // Custom fixed value
}

// This is used to calculate the center point position for the modal.
public enum ModalCenterPosition {
  case Center        // Center of the screen
  case TopCenter     // Center of the top half of the screen
  case BottomCenter  // Center of the bottom half of the screen
  case Custom(centerPoint: CGPoint)  // Custom fixed center point.
  case CustomOrigin(origin: CGPoint) // Custom fixed origin point.
}
```

This allows us to use a fixed value when we want
```swift
let width = ModalSize.Custom(size: 300)
```

But also let Presentr handle the calculations when we want something more common.
```swift
let height = ModalSize.Full // Whole Screen
```

We could also set a fixed position
```swift
let position = ModalCenterPosition.Custom(centerPoint: CGPoint(x: 150, y: 150))
```

Or let presentr calculate the position
```swift
let position = ModalCenterPosition.Center // Center of the screen
```

So we can mix and match, and have the benefit of a custom PresentationType but still have Presentr calculating the values we don't want to do ourselves.

The following code creates a Presentr object with a custom PresentationType which shows the alert in a small top banner.

```swift
class ViewController: UIViewController{

  let customPresenter: Presentr = {
  
    let width = ModalSize.Full
    let height = ModalSize.Custom(size: 150)
    let center = ModalCenterPosition.CustomOrigin(origin: CGPoint(x: 0, y: 0))

    let customType = PresentationType.Custom(width: width, height: height, center: center)

    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .CoverVerticalFromTop
    customPresenter.roundCorners = false
    return customPresenter
    
  }()

}
```

<img src="http://danielozano.com/PresentrScreenshots/CustomPresentationType.png" width="250">


#### Presentr also comes with a cool AlertViewController baked in if you want something different from Apple's. The API is very similar to Apple's alert controller.

<img src="http://danielozano.com/PresentrScreenshots/Alert2.png" width="250">

```swift

  let title = "Are you sure?"
  let body = "There is no way to go back after you do this!"
  
  let controller = Presentr.alertViewController(title: title, body: body)
  
  let deleteAction = AlertAction(title: "Sure 🕶", style: .Destructive) {
    print("Deleted!")
  }
  
  let okAction = AlertAction(title: "NO, sorry 🙄", style: .Cancel){
    print("Ok!")
  }
  
  controller.addAction(deleteAction)
  controller.addAction(okAction)
  
  presenter.presentationType = .Alert
  customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)

```

## Requirements
* Xcode 7.3+
* iOS 8.0+
* Swift 2.2+

## Documentation

Read the [docs](http://danielozano.com/PresentrDocs/). Generated with [jazzy](https://github.com/realm/jazzy).

## To Do
- Add more presentation types
- Add more transition types (animations)
- Add other baked in View Controller's for common uses (like the AlertViewController)
- Add Testing

## Author
[Daniel Lozano](http://danielozano.com) <br>
iOS Developer @ [Icalia Labs](http://www.icalialabs.com)
<br><br>
Logo design by [Eduardo Higareda](http://eldelentes.mx)<br>
Alert design by [Noe Araujo](http://www.noearaujo.com)

## License
Presentr is released under the MIT license.  
See LICENSE for details.
