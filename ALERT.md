## AlertViewController

Presentr also comes with a cool AlertViewController baked in if you want something different from Apple's. The API is very similar to Apple's alert controller.

```swift

  let alertViewController = AlertViewController(title: title, body: body)

  let deleteAction = AlertAction(title: "Sure 🕶", style: .destructive) { (action) in
    print("Deleted!")
  }

  let okAction = AlertAction(title: "Ok", style: .custom(textColor: .green)) { (action) in
    print("Ok!")
  }
  
  controller.addAction(deleteAction)
  controller.addAction(okAction)

  presenter.presentationType = .alert
  customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)

```

<img src="http://danielozano.com/Presentr/Screenshots/Alert2.png" width="250">
