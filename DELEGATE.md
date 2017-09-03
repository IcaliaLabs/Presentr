## Delegate

You can conform to the PresentrDelegate protocol in your presented view controller if you want to get a callback. Using this method you can prevent the view controller from being dismissed when the background is tapped and/or perform something before it's dismissed.

```swift
func presentrShouldDismiss(keyboardShowing: Bool) -> Bool { }
```
