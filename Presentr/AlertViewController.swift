//
//  AlertViewController.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

public protocol AlertViewControllerDelegate: class{
    func alertDidSelectCancel(controller: AlertViewController)
    func alertDidSelectOk(controller: AlertViewController)
}

public extension AlertViewControllerDelegate where Self: UIViewController {
    func alertDidSelectCancel(controller: AlertViewController){
        print("ALERT CONTROLLER: Did select cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alertDidSelectOk(controller: AlertViewController){
        print("ALERT CONTROLLER: Did select OK")
    }
}

public class AlertViewController: UIViewController {

    public weak var delegate: AlertViewControllerDelegate?
    
    public var titleText: String?
    public var bodyText: String?
    
    public var cancelText: String?
    public var okText: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        updateScreen()        
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setup
    
    func updateScreen(){
        titleLabel.text = titleText ?? "Title"
        bodyLabel.text = bodyText ?? "Body"
        
        cancelButton.setTitle(cancelText ?? "NO, SORRY 🕶", forState: .Normal)
        okButton.setTitle(okText ?? "YES, PLEASE ☹️", forState: .Normal)
    }

    // MARK: IBAction's
    
    @IBAction func didSelectCancel(sender: AnyObject) {
        delegate?.alertDidSelectCancel(self)
    }
    
    @IBAction func didSelectOk(sender: AnyObject) {
        delegate?.alertDidSelectOk(self)
    }
}
