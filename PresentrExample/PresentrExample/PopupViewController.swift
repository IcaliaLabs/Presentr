//
//  PopupViewController.swift
//  PresentrExample
//
//  Created by Daniel Lozano on 8/29/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit
import Presentr

class PopupViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didSelectDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }


}

// MARK: - Presentr Delegate

extension PopupViewController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        print("Dismissing View Controller")
        return !keyboardShowing
    }
    
}

// MARK: - UITextField Delegate

extension PopupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
