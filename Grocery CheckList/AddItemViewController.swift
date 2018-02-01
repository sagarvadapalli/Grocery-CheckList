//
//  AddItemViewController.swift
//  Grocery CheckList
//
//  Created by sagar vadapalli on 6/8/17.
//  Copyright © 2017 sagar vadapalli. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate {
    func controller(_ controller: AddItemViewController, didSaveItemWithName name: String, andPrice price: Float)
}

class AddItemViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!

    
    var delegate: AddItemViewControllerDelegate?
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: -
    // MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let name = nameTextField.text {
            // Notify Delegate
            delegate?.controller(self, didSaveItemWithName: name, andPrice: 1)
            
            // Dismiss View Controller
            dismiss(animated: true, completion: nil)
        }
    }

}
