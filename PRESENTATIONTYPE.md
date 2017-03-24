## Dynamic PresentationType

This new PresentationType uses Auto Layout to calculate the sizing for the ViewController.

Make sure that your constraints are not ambigous. You have to set ALL constraints in both X and Y coordinates in order for it to work properly. If you have a UILabel that you want to allow to expand set the lines to 0.

## Creating a custom PresentationType

If you need to present a controller in a way that is not handled by the included presentation types you can create your own.

You create a custom **PresentationType** using the **.custom** case on the **PresentationType** enum.

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
