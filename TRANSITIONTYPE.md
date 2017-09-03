## Creating a custom TransitionType

To create a custom TransitionType you have to modify an existing **PresentrAnimation** or create your own. Then initialize a **.custom** TransitionType with your animation.

### Modify an existing one

Here we get the existing **CoverVerticalAnimation** and modify it to create a CoverVerticalWithSpring transition.

```swift
let animation = CoverVerticalAnimation(options: .spring(duration: 2.0,
                                                        delay: 0,
                                                        damping: 0.5,
                                                        velocity: 0))
                                                        
let coverVerticalWithSpring = TransitionType.custom(animation)

presenter.transitionType = coverVerticalWithSpring
presenter.dismissTransitionType = coverVerticalWithSpring
```

You can initialize any **PresentrAnimation** subclass with an **AnimationOptions** enum that sets the UIView animation settings to be used.

```swift
public enum AnimationOptions {

    case normal(duration: TimeInterval)
    case spring(duration: TimeInterval, delay: TimeInterval, damping: CGFloat, velocity: CGFloat)

}
```

For example, if you wanted to modify the **CrossDissolve** transition to be much slower, you would do it like so:

```swift
let slowCrossDissolve = CrossDissolveAnimation(options: .normal(duration: 2.0))
presenter.transitionType = TransitionType.custom(slowCrossDissolve)
```

These are the included **PresentrAnimation**'s mapped to their **PresentationType**.

```swift
func animation() -> PresentrAnimation {
    switch self {
    case .crossDissolve:
        return CrossDissolveAnimation()
    case .coverVertical:
        return CoverVerticalAnimation()
    case .coverVerticalFromTop:
        return CoverVerticalFromTopAnimation()
    case .coverHorizontalFromRight:
        return CoverHorizontalAnimation(fromRight: true)
    case .coverHorizontalFromLeft:
        return CoverHorizontalAnimation(fromRight: false)
    ...
    }
}
```

### Create your own custom PresentrAnimation

- Create a class that inherits from **PresentrAnimation**.

Then, either:
- Override the **transform** method. It receives the Container Frame and Final Frame of the presented view controller. You need to return the Initial frame you want for the view controller, that way you can create a simple movement animation.

```swift
class ExpandFromCornerAnimation: PresentrAnimation {

    override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 10, height: 10)
    }

}
```

OR

- Override both beforeAnimation and performAnimation, and optionally, afterAnimation. Take the built-in CrossDissolveAnimation as an example.

```swift
public class CrossDissolveAnimation: PresentrAnimation {

    override public func beforeAnimation(using transitionContext: PresentrTransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 0.0 : 1.0
    }

    override public func performAnimation(using transitionContext: PresentrTransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 1.0 : 0.0
    }

    override public func afterAnimation(using transitionContext: PresentrTransitionContext) {
        transitionContext.animatingView?.alpha = 1.0
    }

}
```

The framework gives you all you need via the **PresentrTransitionContext** struct which is a wrapper which gives you all you need for the animation.

```swift
public struct PresentrTransitionContext {

    let containerView: UIView

    let initialFrame: CGRect

    let finalFrame: CGRect

    let isPresenting: Bool

    let fromViewController: UIViewController?

    let toViewController: UIViewController?

    let fromView: UIView?

    let toView: UIView?

    let animatingViewController: UIViewController?
    
    let animatingView: UIView?
    
}
```

Finally, create a custom TransitionType with your custom animation.

```swift
presenter.transitionType = .custom(ExpandFromCornerAnimation())
```
