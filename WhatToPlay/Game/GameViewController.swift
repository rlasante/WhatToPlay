//
//  GameViewController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 10/8/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import Material
import UIKit

class GameViewController: UIViewController {
    var game: Game!

    private var card: ImageCard!

    private var imageView: UIImageView!
    private var toolbar: Toolbar!
    private var moreButton: IconButton!
    private var contentView: UILabel!

    @IBOutlet weak var headerImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if game == nil {
            assertionFailure("Game Should never be nil by the time we're loading the view")
            return
        }
//        navigationItem.title = game.name
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }

//        if let imageUrl = game.imageURL {
//            headerImage.af_setImage(withURL: imageUrl) { _ in
//                self.headerImage.image = self.headerImage.image?.resize(toWidth: self.view.bounds.width)
//            }
//        }

        prepareImageView()
        prepareMoreButton()
        prepareToolbar()
        prepareContentView()
        prepareCard()
    }

    func prepareImageView() {
        imageView = UIImageView()
        imageView.clipsToBounds = true
        if let imageUrl = game.imageURL {
            imageView.af_setImage(withURL: imageUrl) { _ in
                self.imageView.image = self.imageView.image?.resize(toWidth: self.view.bounds.width - 40)
                self.view.setNeedsLayout()
            }
        }
    }

    func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.grey.base)
    }

    func prepareToolbar() {
        toolbar = Toolbar(rightViews: [moreButton])

        toolbar.title = game.name
        toolbar.titleLabel.textAlignment = .left

        toolbar.detail = "Build Beautiful Software"
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.grey.base
    }

    fileprivate func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 10
        contentView.text = game.description
        contentView.font = RobotoFont.regular(with: 14)
    }

    func prepareCard() {
        card = ImageCard()

        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square3
//        card.toolbarEdgeInsets.bottom = 0
//        card.toolbarEdgeInsets.right = 8

        card.imageView = imageView

        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .square3

//        card.bottomBar = bottomBar
//        card.bottomBarEdgeInsetsPreset = .wideRectangle2

        view.layout(card).horizontally(left: 20, right: 20).centerHorizontally().top(20)
//        view.layout(card).horizontally(left: 20, right: 20)
    }

}
