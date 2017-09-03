## AlertViewController

Presentr also comes with a cool AlertViewController baked in if you want something different from Apple's. The API is very similar to Apple's alert controller.

```swift

  let title = "Are you sure?"
  let body = "There is no way to go back after you do this!"

  let controller = Presentr.alertViewController(title: title, body: body)

  let deleteAction = AlertAction(title: "Sure 🕶", style: .destructive) {
    print("Deleted!")
  }

  let okAction = AlertAction(title: "NO, sorry 🙄", style: .cancel) {
    print("Ok!")
  }
  
  let okAction = AlertAction(title: "Ok", style: .custom(textColor: .green)) {
    print("Ok!")
  }
  
  controller.addAction(deleteAction)
  controller.addAction(okAction)

  presenter.presentationType = .alert
  customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)

```

<img src="http://danielozano.com/Presentr/Screenshots/Alert2.png" width="250">
