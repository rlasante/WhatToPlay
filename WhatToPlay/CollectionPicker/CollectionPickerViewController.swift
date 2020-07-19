//
//  CollectionPickerViewController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/18/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Combine
import UIKit

class CollectionPickerViewController: UIViewController, StoryboardInitializable, ViewModelDependent {

    var viewModel: CollectionPickerViewModel!

    @IBOutlet var sourcesView: UIStackView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var selectButton: UIButton!

    var cancelables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelable = viewModel.sources
            .map { sources in
                return sources.map { source -> UIButton in
                    let button = UIButton()
                    button.setTitle(source.name, for: .normal)
                    button.setTitleColor(.black, for: .normal)
                    let selectSource = button.publisher(for: .touchUpInside)
                        .sink(receiveValue: { _ in
                            self.viewModel.source.send(source)
                        })
                    let colorSource = self.viewModel.source.sink(receiveValue: { model in
                        button.backgroundColor = model == source ? .blue : .clear
                    })
                    self.cancelables.insert(selectSource)
                    self.cancelables.insert(colorSource)
                    return button
                }
            }.sink(receiveCompletion: {_ in }, receiveValue: { sourceButtons in
                self.sourcesView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                sourceButtons.forEach { self.sourcesView.addArrangedSubview($0) }
            })
        cancelables.insert(cancelable)

        // Do any additional setup after loading the view.

        let username = self.usernameTextField.publisher(for: .editingChanged)
            .compactMap { control in
                (control as? UITextField)?.text
            }
            .sink { text in
                self.viewModel.username.send(text)
            }
        cancelables.insert(username)

        let selected =
            selectButton.publisher(for: .touchUpInside)
            .sink(receiveValue: { _ in
                self.viewModel.reload.send(())
            })
        cancelables.insert(selected)

        let collection = viewModel.collections
            .compactMap { $0.first }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { collection in
            self.viewModel.collection.send(collection)
        })
        cancelables.insert(collection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
