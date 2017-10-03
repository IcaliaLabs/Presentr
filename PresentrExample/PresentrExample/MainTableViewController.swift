//
//  MainTableViewController.swift
//  PresentrExample
//
//  Created by Daniel Lozano on 11/7/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit
import Presentr

enum ExampleSection {

    case alert
    case popup
    case topHalf
    case bottomHalf
    case advanced
    case other

    static var allSections: [ExampleSection] {
        return [.alert, .popup, .topHalf, .bottomHalf, .advanced, .other]
    }

    var items: [ExampleItem] {
        switch self {
        case .alert:
            return [.alertDefault, .alertCustom, .alertWithout]
        case .popup:
            return [.popupDefault, .popupCustom]
        case .topHalf:
            return [.topHalfDefault, .topHalfCustom]
        case .bottomHalf:
            return [.bottomHalfDefault, .bottomHalfCustom]
        case .other:
            return [.backgroundBlur, .customBackground, .keyboardTest, .fullScreen]
        case .advanced:
            return [.custom, .customAnimation, .modifiedAnimation, .coverVerticalWithSpring, .dynamicSize, .currentContext]
        }
    }

}

enum ExampleItem: String {

    case alertDefault = "Alert with default animation"
    case alertCustom = "Alert with custom animation"
    case alertWithout = "Alert without animation"

    case popupDefault = "Popup with default animation"
    case popupCustom = "Popup with custom animation"

    case topHalfDefault = "TopHalf with default animation"
    case topHalfCustom = "TopHalf with custom animation"

    case bottomHalfDefault = "BottomHalf with default animation"
    case bottomHalfCustom = "BottomHalf with custom animation"

    case fullScreen = "Full Screen"
    case customBackground = "Custom background"
    case keyboardTest = "Keyboard translation"
    case backgroundBlur = "Background blur"

    case custom = "Custom presentation"
    case customAnimation = "Custom user created animation"
    case modifiedAnimation = "Modified built in animation"
    case coverVerticalWithSpring = "Cover vertical with spring"
    case currentContext = "Using a custom context"
    case dynamicSize = "Using dynamic sizing (Auto Layout)"

    var action: Selector {
        switch self {
        case .alertDefault:
            return #selector(MainTableViewController.alertDefault)
        case .alertCustom:
            return #selector(MainTableViewController.alertCustom)
        case .alertWithout:
            return #selector(MainTableViewController.alertDefaultWithoutAnimation)

        case .popupDefault:
            return #selector(MainTableViewController.popupDefault)
        case .popupCustom:
            return #selector(MainTableViewController.popupCustom)

        case .topHalfDefault:
            return #selector(MainTableViewController.topHalfDefault)
        case .topHalfCustom:
            return #selector(MainTableViewController.topHalfCustom)

        case .bottomHalfDefault:
            return #selector(MainTableViewController.bottomHalfDefault)
        case .bottomHalfCustom:
            return #selector(MainTableViewController.bottomHalfCustom)

        case .fullScreen:
            return #selector(MainTableViewController.fullScreenPresentation)
        case .backgroundBlur:
            return #selector(MainTableViewController.backgroundBlurTest)
        case .keyboardTest:
            return #selector(MainTableViewController.keyboardTranslationTest)
        case .customBackground:
            return #selector(MainTableViewController.customBackgroundPresentation)


        case .custom:
            return #selector(MainTableViewController.customPresentation)
        case .customAnimation:
            return #selector(MainTableViewController.customAnimation)
        case .modifiedAnimation:
            return #selector(MainTableViewController.modifiedAnimation)
        case .coverVerticalWithSpring:
            return #selector(MainTableViewController.coverVerticalWithSpring)
        case .currentContext:
            return #selector(MainTableViewController.currentContext)
        case .dynamicSize:
            return #selector(MainTableViewController.dynamicSize)
        }
    }

}

class MainTableViewController: UITableViewController {

    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()

    let dynamicSizePresenter: Presentr = {
        let presentationType = PresentationType.dynamic(center: .center)
        let presenter = Presentr(presentationType: presentationType)
        return presenter
    }()

    let customPresenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 0.20)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)

        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = false
        customPresenter.backgroundColor = .green
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        return customPresenter
    }()

    let customBackgroundPresenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 0.20)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .coverVerticalFromTop
        
        customPresenter.backgroundColor = .yellow
        customPresenter.backgroundOpacity = 0.5
        
        let view = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        view.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: UIScreen.main.bounds.height / 2 - 50, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        customPresenter.customBackgroundView = view

        return customPresenter
    }()

    lazy var alertController: AlertViewController = {
        let alertController = Presentr.alertViewController(title: "Are you sure? ⚠️", body: "This action can't be undone!")
        let cancelAction = AlertAction(title: "NO, SORRY! 😱", style: .cancel) { alert in
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "DO IT! 🤘", style: .destructive) { alert in
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }()

    lazy var popupViewController: PopupViewController = {
        let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController")
        return popupViewController as! PopupViewController
    }()

    var logoView: UIImageView {
        let logoView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        logoView.contentMode = .scaleAspectFit
        logoView.frame.size.width = 30
        logoView.frame.size.height = 30
        return logoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = logoView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ExampleSection.allSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = ExampleSection.allSections[section]
        return section.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCell", for: indexPath) as! ExampleTableViewCell

        let item = itemFor(indexPath: indexPath)
        cell.exampleLabel.text = item.rawValue

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleItem(itemFor(indexPath: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: ExampleItem handling

    func itemFor(indexPath: IndexPath) -> ExampleItem {
        let section = ExampleSection.allSections[indexPath.section]
        return section.items[indexPath.row]
    }

    func handleItem(_ item: ExampleItem) {
        performSelector(onMainThread: item.action, with: nil, waitUntilDone: false)
    }

}

// MARK: - Presentation Examples

extension MainTableViewController {

    // MARK: Alert

    @objc func alertDefault() {
        presenter.presentationType = .alert
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func alertCustom() {
        presenter.presentationType = .alert
        presenter.transitionType = .coverHorizontalFromLeft
        presenter.dismissTransitionType = .coverHorizontalFromRight
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func alertDefaultWithoutAnimation() {
        presenter.presentationType = .alert
        presenter.dismissAnimated = false
        customPresentViewController(presenter, viewController: alertController, animated: false, completion: nil)
    }

    // MARK: Popup

    @objc func popupDefault() {
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func popupCustom() {
        presenter.presentationType = .popup
        presenter.transitionType = .coverHorizontalFromRight
        presenter.dismissTransitionType = .coverVerticalFromTop
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    // MARK: Top Half

    @objc func topHalfDefault() {
        presenter.presentationType = .topHalf
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func topHalfCustom() {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverHorizontalFromLeft
        presenter.dismissTransitionType = .coverVerticalFromTop
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    // MARK: Bottom Half

    @objc func bottomHalfDefault() {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func bottomHalfCustom() {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverHorizontalFromLeft
        presenter.transitionType = .crossDissolve
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    // MARK: Other

    @objc func fullScreenPresentation() {
        presenter.presentationType = .fullScreen
        presenter.transitionType = .coverVertical
        presenter.dismissTransitionType = .crossDissolve
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func customBackgroundPresentation() {
        customPresentViewController(customBackgroundPresenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func keyboardTranslationTest() {
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        presenter.dismissOnSwipe = true
        customPresentViewController(presenter, viewController: popupViewController, animated: true, completion: nil)
    }

    @objc func backgroundBlurTest() {
        presenter.presentationType = .alert
        presenter.blurBackground = true
        alertDefault()
        presenter.blurBackground = false
    }

    // MARK: Advanced

    @objc func customPresentation() {
        customPresentViewController(customPresenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func customAnimation() {
        presenter.presentationType = .alert
        presenter.transitionType = TransitionType.custom(CustomAnimation())
        presenter.dismissTransitionType = TransitionType.custom(CustomAnimation())
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func modifiedAnimation() {
        presenter.presentationType = .alert
        let modifiedAnimation = CrossDissolveAnimation(options: .normal(duration: 1.0))
        presenter.transitionType = TransitionType.custom(modifiedAnimation)
        presenter.dismissTransitionType = TransitionType.custom(modifiedAnimation)
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func coverVerticalWithSpring() {
        presenter.presentationType = .alert
        let animation = CoverVerticalAnimation(options: .spring(duration: 2.0,
                                                                delay: 0,
                                                                damping: 0.5,
                                                                velocity: 0))
        let coverVerticalWithSpring = TransitionType.custom(animation)
        presenter.transitionType = coverVerticalWithSpring
        presenter.dismissTransitionType = coverVerticalWithSpring
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }

    @objc func dynamicSize() {
        let dynamicVC = storyboard!.instantiateViewController(withIdentifier: "DynamicViewController")
        customPresentViewController(dynamicSizePresenter, viewController: dynamicVC, animated: true, completion: nil)
    }

    @objc func currentContext() {
        let splitVC = storyboard!.instantiateViewController(withIdentifier: "SplitViewController")
        navigationController?.pushViewController(splitVC, animated: true)
    }

}
