# Presentr

[![Version](https://img.shields.io/cocoapods/v/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![Platform](https://img.shields.io/cocoapods/p/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![License](https://img.shields.io/cocoapods/l/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)

*Presentr is a micro-framework, a simple wrapper on top of the Custom View Controller Presentation API introduced in iOS 8.*

## About

It is meant to handle the most typical custom presentations, but it is has been designed so new ones can be added easily.
Just send me a pull request and I will add it.

## Requirements

* Xcode 7.3+
* iOS 8.0+
* Swift 2.2+

## Installation

#### [Cocoapods](http://cocoapods.org)

```ruby
use_frameworks!

pod 'Presentr'
```

## Documentation

Read the [docs](http://danielozano.com/PresentrDocs/). Generated with [jazzy](https://github.com/realm/jazzy).

## Usage

#### Create a Presentr object
```swift
let presenter = Presentr(presentationType: .Alert)
presenter.transitionType = TransitionType.CoverHorizontalFromRight
```

#### Optionally create an AlertViewController. API is very similar to Apple's alert controller.
```swift
let alertController = Presentr.alertViewController(title: "Warning", body: "This action can't be undone")

let cancelAction = AlertAction(title: "Cancel", style: .Cancel) {
  print("CANCEL!!")
}
        
let okAction = AlertAction(title: "Ok", style: .Destructive) { alert in
  print("OK!!")
}
        
alertController.addAction(cancelAction)
alertController.addAction(okAction)
```

#### Present the view controller using a helper method provided as an extension on UIViewController.
```swift
customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
```

## Author
[Daniel Lozano](http://danielozano.com) <br>
iOS Developer @ [Icalia Labs](http://www.icalialabs.com)

## License
Presentr is released under the MIT license.  
See LICENSE for details.
