<img src="http://danielozano.com/PresentrScreenshots/PresentrLogo.png">

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

It is **important to hold on to the Presentr object as an instance variable(property)** on the presenting/current View Controller since internally it will be used as a delegate for the custom presentation.
```swift
let presenter = Presentr(presentationType: .Alert)
presenter.transitionType = .CoverHorizontalFromRight // Optional
```

Both types can be changed later on in order to reuse the Presentr object for other presentations.
```swift
presenter.presentationType = .Popup
presenter.transitionType = .CoverVerticalFromTop
```

#### Present the view controller.
Instantiate the View Controller you want to present. Remember to setup autolayout on it so it can be displayed well on any size.
```swift
let controller = SomeViewController()
customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
```
This is a helper method provided for you as an extension on UIViewController. It handles setting the Presentr object as the delegate for the presentation & transition. 

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
