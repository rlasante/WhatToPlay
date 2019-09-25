//
//  GameTableViewCell.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/7/18.
//  Copyright © 2018 rlasante. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let imageView = imageView, imageView.image != nil else {
            return
        }
        let imageViewSide: CGFloat = 50
        let y = bounds.height / 2 - imageViewSide / 2
        let imageViewFrame = CGRect(x: 15, y: y, width: imageViewSide, height: imageViewSide)
        imageView.frame = imageViewFrame

//        var originalContentFrame = contentView.frame
//        let rightPoint = originalContentFrame.maxX
        let desiredLeft = imageViewFrame.maxX + 15
        var originalTitleFrame = textLabel!.frame
        var originalDetailFrame = detailTextLabel!.frame

        originalTitleFrame.origin.x = desiredLeft
        originalDetailFrame.origin.x = desiredLeft
        textLabel?.frame = originalTitleFrame
        detailTextLabel?.frame = originalDetailFrame
//        let xDelta = originalContentFrame.minX - desiredLeft
//        originalContentFrame.origin.x = desiredLeft
//        originalContentFrame.size.width += xDelta
//        contentView.frame = originalContentFrame
    }

}
