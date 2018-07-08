//
//  HeaderTableViewCell.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 10/22/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myRatingLabel: UILabel!
    @IBOutlet weak var myPlayCountLabel: UILabel!

    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var suggestedPlayerCountLabel: UILabel!
    @IBOutlet weak var bestPlayerCountLabel: UILabel!
}
