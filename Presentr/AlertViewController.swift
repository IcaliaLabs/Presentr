//
//  AlertViewController.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

public enum AlertActionStyle{
    
    case Default
    case Cancel
    case Destructive
    
    func color() -> UIColor{
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

public typealias AlertActionHandler = (() -> Void)

public class AlertAction{
    
    let title: String
    let style: AlertActionStyle
    let handler: AlertActionHandler?
    
    public init(title: String, style: AlertActionStyle, handler: AlertActionHandler?){
        self.title = title
        self.style = style
        self.handler = handler
    }
    
}

enum Font: String {
    
    case Montserrat = "Montserrat-Regular"
    case SourceSansPro = "SourceSansPro-Regular"
    
    func font(size: CGFloat = 15.0) -> UIFont{
        return UIFont(name: self.rawValue, size: size)!
    }
    
}

struct ColorPalette {
    
    static let grayColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1)
    static let greenColor = UIColor(red: 58.0/255.0, green: 213.0/255.0, blue: 91.0/255.0, alpha: 1)
    static let redColor = UIColor(red: 255.0/255.0, green: 103.0/255.0, blue: 100.0/255.0, alpha: 1)
    
}

public class AlertViewController: UIViewController {
    
    public var titleText: String?
    public var bodyText: String?
    
    public var autoDismiss: Bool = true
    public var dismissAnimated: Bool = true
    
    private var actions = [AlertAction]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButtonWidthConstraint: NSLayoutConstraint!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if actions.isEmpty{
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
        if actions.count == 1{
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
    
    public func addAction(action: AlertAction){
        guard actions.count < 2 else { return }
        actions += [action]
    }
    
    // MARK: Setup
    
    func setupFonts(){
        titleLabel.font = Font.Montserrat.font()
        bodyLabel.font = Font.SourceSansPro.font()
        firstButton.titleLabel?.font = Font.Montserrat.font(11.0)
        secondButton.titleLabel?.font = Font.Montserrat.font(11.0)
    }
    
    func setupLabels(){
        titleLabel.text = titleText ?? "Alert"
        bodyLabel.text = bodyText ?? "This is an alert."
    }
    
    func setupButtons(){
        guard let firstAction = actions.first else { return }
        apply(firstAction, toButton: firstButton)
        if actions.count == 2{
            let secondAction = actions.last!
            apply(secondAction, toButton: secondButton)
        }else{
            secondButton.removeFromSuperview()
        }
    }
    
    func apply(action: AlertAction, toButton: UIButton){
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
    
    func dismiss(){
        guard autoDismiss else { return }
        dismissViewControllerAnimated(dismissAnimated, completion: nil)
    }
    
}

// MARK: - Font Loading

extension AlertViewController {
    
    struct PresentrStatic{
        static var onceToken: dispatch_once_t = 0
    }
    
    func loadFonts(){
        dispatch_once(&PresentrStatic.onceToken) {
            self.loadFont(Font.Montserrat.rawValue)
            self.loadFont(Font.SourceSansPro.rawValue)
        }
    }
    
    func loadFont(name: String) -> Bool{
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
                //print(error)
                return false
            }
        }else{
            return false
        }
        return true
    }
    
}
