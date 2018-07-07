//
//  MiniFilterView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/6/18.
//  Copyright © 2018 rlasante. All rights reserved.
//

import UIKit

@IBDesignable class MiniFilterViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    @IBInspectable var cornerRadius: CGFloat = 6 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
