//
//  GameViewController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 10/8/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import Material
import UIKit

class GameViewController: UITableViewController {
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
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderTableViewCell
        cell.titleLabel.text = game.name
        cell.playerCountLabel.text = game.playerCount.description
        cell.suggestedPlayerCountLabel.text = "Suggested: \(game.suggestedPlayerCount.description)"
        if let bestPlayerCount = game.bestPlayerCount {
            cell.bestPlayerCountLabel.text = "Best: \([bestPlayerCount].description)"
        } else {
            cell.bestPlayerCountLabel.text = nil
        }
        if let imageUrl = game.imageURL {
            cell.backgroundImageView.af.setImage(withURL: imageUrl, completion: { _ in
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
        }
        // TODO make these actually work
        cell.ratingLabel.text = "8.5"
        cell.myRatingLabel.isHidden = true
        cell.myPlayCountLabel.isHidden = true
        return cell
    }
}
