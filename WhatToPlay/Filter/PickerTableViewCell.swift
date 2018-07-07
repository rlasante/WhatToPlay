//
//  PickerTableViewCell.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/23/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {
    @IBOutlet weak var picker: UIPickerView!
}

protocol UIPickerViewListener {
    var pickerView: UIPickerView? { get set }
}

class PickerController<DataType: PickerData>: NSObject, UIPickerViewListener, UIPickerViewDataSource, UIPickerViewDelegate {
    var pickerView: UIPickerView? {
        didSet {
            guard let pickerView = pickerView else { return }
            for (component, rows) in data.enumerated() {
                let index = rows.index(where: {
                    guard let newComponentLabel = selectedData[component]?.label else { return false }
                    return $0.label == newComponentLabel
                })
                if let index = index {
                    pickerView.selectRow(index, inComponent: component, animated: true)
                }
            }
        }
    }
    var data: [[DataType]]
    var selectedData: [DataType?] {
        willSet { assert(newValue.count == data.count) }
        didSet {
            guard let pickerView = pickerView else { return }
            for (component, rows) in data.enumerated() {
                let index = rows.index(where: {
                    guard let newComponentLabel = selectedData[component]?.label else { return false }
                    return $0.label == newComponentLabel
                })

                if let index = index {
                    pickerView.selectRow(index, inComponent: component, animated: true)
                }
            }
        }
    }

    init(data: [[DataType]]) {
        self.data = data
        selectedData = [DataType?](repeating: nil, count: data.count)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row].label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedData[component] = data[component][row]
    }
}

protocol PickerData {
    var label: String { get }
}

extension GameCategory: PickerData {
    var label: String { return self.rawValue }
}

extension GameMechanic: PickerData {
    var label: String { return self.rawValue }
}

extension Int: PickerData {
    var label: String { return description }
}
