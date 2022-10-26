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

    public let title: String
    public let style: AlertActionStyle
    public let handler: AlertActionHandler?

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

    case `default`
    case cancel
    case destructive
    case custom(textColor: UIColor)

    /**
     Decides which color to use for each style

     - returns: UIColor representing the color for the current style
     */
    func color() -> UIColor {
        switch self {
        case .default:
            return ColorPalette.greenColor
        case .cancel:
            return ColorPalette.grayColor
        case .destructive:
            return ColorPalette.redColor
        case let .custom(color):
            return color
        }
    }

}

private enum Font: String {

    case Montserrat = "Montserrat-Regular"
    case SourceSansPro = "SourceSansPro-Regular"

    func font(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }

}

private struct ColorPalette {

    static let grayColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1)
    static let greenColor = UIColor(red: 58.0/255.0, green: 213.0/255.0, blue: 91.0/255.0, alpha: 1)
    static let redColor = UIColor(red: 255.0/255.0, green: 103.0/255.0, blue: 100.0/255.0, alpha: 1)

}

protocol CornerRadiusSettable {

	func customContainerViewSetCornerRadius(_ radius: CGFloat)

}

/// UIViewController subclass that displays the alert
public class AlertViewController: UIViewController, CornerRadiusSettable {

    /// Text that will be used as the title for the alert
	public var titleText: String = "" {
		didSet {
			titleLabel?.text = titleText
		}
	}

    /// Text that will be used as the body for the alert
	public var bodyText: String = "" {
		didSet {
			bodyLabel?.text = bodyText
		}
	}

    /// If set to false, alert wont auto-dismiss the controller when an action is clicked. Dismissal will be up to the action's handler. Default is true.
    public var autoDismiss: Bool = true

    /// If autoDismiss is set to true, then set this property if you want the dismissal to be animated. Default is true.
    public var dismissAnimated: Bool = true

	public let titleFont: UIFont?

	public let bodyFont: UIFont?

	public let buttonFont: UIFont?

    fileprivate var actions = [AlertAction]()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var firstButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!
	@IBOutlet private weak var containerView: UIView!

	public init(title: String? = nil, body: String? = nil, titleFont: UIFont? = nil, bodyFont: UIFont? = nil, buttonFont: UIFont? = nil) {
		if let title = title {
			titleText = title
		}

		if let body = body {
			bodyText = body
		}

		self.titleFont = titleFont
		self.bodyFont = bodyFont
		self.buttonFont = buttonFont

		super.init(nibName: "AlertViewController", bundle: Bundle(for: type(of: self)))
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("Unsupported initializer, please use init()")
	}

    override public func viewDidLoad() {
        super.viewDidLoad()

        if actions.isEmpty {
            let okAction = AlertAction(title: "ok 🕶", style: .default, handler: nil)
            addAction(okAction)
        }

		setupContainerView()
        setupFonts()
        setupLabels()
        setupButtons()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: AlertAction's

    /**
     Adds an 'AlertAction' to the alert controller. There can be maximum 2 actions. Any more will be ignored. The order is important.

     - parameter action: The 'AlertAction' to be added
     */
    public func addAction(_ action: AlertAction) {
        guard actions.count < 2 else { return }
        actions += [action]
    }

    // MARK: Setup, CornerRadiusSettable

	func customContainerViewSetCornerRadius(_ radius: CGFloat) {
		containerView.layer.cornerRadius = radius
	}

	private func setupContainerView() {
		containerView.clipsToBounds = true
	}

    private func setupFonts() {
		if titleFont == nil || bodyFont == nil || buttonFont == nil {
			loadFonts
		}

        titleLabel.font = titleFont ?? Font.Montserrat.font()
        bodyLabel.font = bodyFont ?? Font.SourceSansPro.font()
        firstButton.titleLabel?.font = buttonFont ?? Font.Montserrat.font(11.0)
        secondButton.titleLabel?.font = buttonFont ?? Font.Montserrat.font(11.0)
    }

    private func setupLabels() {
        titleLabel.text = titleText
        bodyLabel.text = bodyText
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

    private func apply(_ action: AlertAction, toButton: UIButton) {
        let title = action.title.uppercased()
        let style = action.style
        toButton.setTitle(title, for: UIControl.State())
        toButton.setTitleColor(style.color(), for: UIControl.State())
    }

    // MARK: IBAction's

    @IBAction func didSelectFirstAction(_ sender: AnyObject) {
        guard let firstAction = actions.first else { return }
		firstAction.handler?()
        dismiss()
    }

    @IBAction func didSelectSecondAction(_ sender: AnyObject) {
        guard let secondAction = actions.last, actions.count == 2 else { return }
		secondAction.handler?()
        dismiss()
    }

    // MARK: Helper's

    func dismiss() {
        guard autoDismiss else { return }
        self.dismiss(animated: dismissAnimated, completion: nil)
    }

}

// MARK: - Font Loading

let loadFonts: () = {
    let loadedFontMontserrat = AlertViewController.loadFont(Font.Montserrat.rawValue)
    let loadedFontSourceSansPro = AlertViewController.loadFont(Font.SourceSansPro.rawValue)
    if loadedFontMontserrat && loadedFontSourceSansPro {
        print("LOADED FONTS")
    }
}()

extension AlertViewController {

    static func loadFont(_ name: String) -> Bool {
        let bundle = Bundle(for: self)
        guard let fontPath = bundle.path(forResource: name, ofType: "ttf"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: fontPath)),
            let provider = CGDataProvider(data: data as CFData),
            let font = CGFont(provider)
        else {
            return false
        }

        var error: Unmanaged<CFError>?

        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        if !success {
            print("Error loading font. Font is possibly already registered.")
            return false
        }

        return true
    }

}
