//
//  AlertViewController.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

public typealias AlertActionHandler = (() -> Void)

/// Describes each action that is going to be shown in the 'AlertViewController'
public class AlertAction {

    let title: String
    let style: AlertActionStyle
    let handler: AlertActionHandler?

    /**
     Initialized an 'AlertAction'

     - parameter title:   The title for the action, that will be used as the title for a button in the alert controller
     - parameter style:   The style for the action, that will be used to style a button in the alert controller.
     - parameter handler: The handler for the action, that will be called when the user clicks on a button in the alert controller.

     - returns: An inmutable AlertAction object
     */
    public init(title: String, style: AlertActionStyle, handler: AlertActionHandler?) {
        self.title = title
        self.style = style
        self.handler = handler
    }

}

/**
 Describes the style for an action, that will be used to style a button in the alert controller.

 - Default:     Green text label. Meant to draw attention to the action.
 - Cancel:      Gray text label. Meant to be neutral.
 - Destructive: Red text label. Meant to warn the user about the action.
 */
public enum AlertActionStyle {

    case Default
    case Cancel
    case Destructive

    /**
     Decides which color to use for each style

     - returns: UIColor representing the color for the current style
     */
    func color() -> UIColor {
        switch self {
        case .Default:
            return ColorPalette.greenColor
        case .Cancel:
            return ColorPalette.grayColor
        case .Destructive:
            return ColorPalette.redColor
        }
    }

}

private enum Font: String {

    case Montserrat = "Montserrat-Regular"
    case SourceSansPro = "SourceSansPro-Regular"

    func font(size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }

}

private struct ColorPalette {

    static let grayColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1)
    static let greenColor = UIColor(red: 58.0/255.0, green: 213.0/255.0, blue: 91.0/255.0, alpha: 1)
    static let redColor = UIColor(red: 255.0/255.0, green: 103.0/255.0, blue: 100.0/255.0, alpha: 1)

}

/// UIViewController subclass that displays the alert
public class AlertViewController: UIViewController {

    /// Text that will be used as the title for the alert
    public var titleText: String?
    /// Text that will be used as the body for the alert
    public var bodyText: String?

    /// If set to false, alert wont auto-dismiss the controller when an action is clicked. Dismissal will be up to the action's handler. Default is true.
    public var autoDismiss: Bool = true
    /// If autoDismiss is set to true, then set this property if you want the dismissal to be animated. Default is true.
    public var dismissAnimated: Bool = true

    private var actions = [AlertAction]()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButtonWidthConstraint: NSLayoutConstraint!

    override public func viewDidLoad() {
        super.viewDidLoad()

        if actions.isEmpty {
            let okAction = AlertAction(title: "ok 🕶", style: .Default, handler: nil)
            addAction(okAction)
        }

        loadFonts()

        setupFonts()
        setupLabels()
        setupButtons()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override public func updateViewConstraints() {
        if actions.count == 1 {
            // If only one action, second button will have been removed from superview
            // So, need to add constraint for first button trailing to superview
            if let constraint = firstButtonWidthConstraint {
                view.removeConstraint(constraint)
            }
            let views = ["button" : firstButton]
            let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[button]-0-|",
                                                                             options: NSLayoutFormatOptions(rawValue: 0),
                                                                             metrics: nil,
                                                                             views: views)
            view.addConstraints(constraints)
        }
        super.updateViewConstraints()
    }

    // MARK: AlertAction's

    /**
     Adds an 'AlertAction' to the alert controller. There can be maximum 2 actions. Any more will be ignored. The order is important.

     - parameter action: The 'AlertAction' to be added
     */
    public func addAction(action: AlertAction) {
        guard actions.count < 2 else { return }
        actions += [action]
    }

    // MARK: Setup

    private func setupFonts() {
        titleLabel.font = Font.Montserrat.font()
        bodyLabel.font = Font.SourceSansPro.font()
        firstButton.titleLabel?.font = Font.Montserrat.font(11.0)
        secondButton.titleLabel?.font = Font.Montserrat.font(11.0)
    }

    private func setupLabels() {
        titleLabel.text = titleText ?? "Alert"
        bodyLabel.text = bodyText ?? "This is an alert."
    }

    private func setupButtons() {
        guard let firstAction = actions.first else { return }
        apply(firstAction, toButton: firstButton)
        if actions.count == 2 {
            let secondAction = actions.last!
            apply(secondAction, toButton: secondButton)
        } else {
            secondButton.removeFromSuperview()
        }
    }

    private func apply(action: AlertAction, toButton: UIButton) {
        let title = action.title.uppercaseString
        let style = action.style
        toButton.setTitle(title, forState: .Normal)
        toButton.setTitleColor(style.color(), forState: .Normal)
    }

    // MARK: IBAction's

    @IBAction func didSelectFirstAction(sender: AnyObject) {
        guard let firstAction = actions.first else { return }
        if let handler = firstAction.handler {
            handler()
        }
        dismiss()
    }

    @IBAction func didSelectSecondAction(sender: AnyObject) {
        guard let secondAction = actions.last where actions.count == 2 else { return }
        if let handler = secondAction.handler {
            handler()
        }
        dismiss()
    }

    // MARK: Helper's

    func dismiss() {
        guard autoDismiss else { return }
        dismissViewControllerAnimated(dismissAnimated, completion: nil)
    }

}

// MARK: - Font Loading

extension AlertViewController {

    struct PresentrStatic {
        static var onceToken: dispatch_once_t = 0
    }

    private func loadFonts() {
        dispatch_once(&PresentrStatic.onceToken) {
            self.loadFont(Font.Montserrat.rawValue)
            self.loadFont(Font.SourceSansPro.rawValue)
        }
    }

    private func loadFont(name: String) -> Bool {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let fontPath = bundle.pathForResource(name, ofType: "ttf") else {
            return false
        }
        let data = NSData(contentsOfFile: fontPath)
        var error: Unmanaged<CFError>?
        let provider = CGDataProviderCreateWithCFData(data)
        if let font = CGFontCreateWithDataProvider(provider) {
            let success = CTFontManagerRegisterGraphicsFont(font, &error)
            if !success {
                print("Error loading font. Font is possibly already registered.")
                return false
            }
        } else {
            return false
        }
        return true
    }

}
