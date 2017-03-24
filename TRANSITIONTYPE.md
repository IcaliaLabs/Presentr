## Creating a custom TransitionType

- Create a class that inherits from **PresentrAnimation**, and override the properties you want to modify.
- Note the **transform** method. It receives the Container Frame and Final Frame of the presented view controller. You need to return the Initial frame you want for the view controller, that way you can create your animation.
```swift
class CustomAnimation: PresentrAnimation {

    override var springDamping: CGFloat {
        return 500
    }

    override var initialSpringVelocity: CGFloat {
        return 1
    }

    override var animationDuration: TimeInterval {
        return 1
    }

    override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 10, height: 10)
    }

}
```

If modifying those properties is not enough, you can handle the animation completely by yourself overriding this method.
```swift
override func customAnimation(using transitionContext: UIViewControllerContextTransitioning) -> Bool {
  // Do your custom animation here, using the transition context.
  return true
}
```
Remember to return true otherwise your custom animation will be ignored. If you implement this method and return true, other properties will be obviously ignored.

Finally, create a custom TransitionType with your custom animation.
```swift
presenter.transitionType = .custom(CustomAnimation())
```
