//
//  ViewController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 6/25/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var getCollectionButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = "Hunter9110"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let username = usernameTextField.text else { return }
        guard let collectionViewController = segue.destination as? GameCollectionViewController else { return }

        BoardGameGeekAPI.getCollection(userName: username)
        .done { [weak collectionViewController] games in
            collectionViewController?.gamesCollection = games
        }.catch { [weak collectionViewController] error in
            print("Error Fetching collection: \(error)")

            let alertController = UIAlertController(title: "Error", message: "Failed to download collection", preferredStyle: UIAlertControllerStyle.alert)
            collectionViewController?.present(alertController, animated: true, completion: nil)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == usernameTextField {
            let oldText = (textField.text ?? "") as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            getCollectionButton.isEnabled = !newText.isEmpty
        }

        return true
    }
}

