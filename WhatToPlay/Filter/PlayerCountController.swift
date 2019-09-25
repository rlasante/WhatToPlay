//
//  PlayerCountController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/23/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

class PlayerCountController: NSObject, UIPickerViewListener, UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerView: UIPickerView? {
        didSet {
            guard let playerCount = playerCount else { pickerView?.selectRow(0, inComponent: 0, animated: true); return }
            let row: Int
            switch playerCount {
            case .count(let value): row = value
            case .range(let min, _): row = min
            }
            pickerView?.selectRow(row, inComponent: 0, animated: true)
        }
    }
    var playerCount: PlayerCount? {
        didSet {
            guard let playerCount = playerCount else { pickerView?.selectRow(0, inComponent: 0, animated: true); return }
            let row: Int
            switch playerCount {
            case .count(let value): row = value
            case .range(let min, _): row = min

            }
            pickerView?.selectRow(row, inComponent: 0, animated: true)
        }
    }

    var onCountChanged: ((PlayerCount)->())?

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard component == 0 else { return 0 }
        return 30
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row > 0 else { playerCount = nil; return }
        playerCount = .count(value: row)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
