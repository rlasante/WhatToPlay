
//  CollectionViewController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/23/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

class GameCollectionViewController: UIViewController, FilterDelegate {

    weak var gamesViewController: GameTableViewController?
    @IBOutlet weak var filterDescriptionView: FilterDescriptionView?
    @IBOutlet weak var filterPillContainer: UICollectionView?

    var gamesCollection: [Game] = [] {
        didSet {
//            guard !oldValue.elementsEqual(gamesCollection) else { return }
            gamesViewController?.games = filteredGames
        }
    }

    var filter: ((Game)->Bool)? {
        didSet {
            gamesViewController?.games = filteredGames
        }
    }

    var filterData: [String : Any] = [:]

    var filteredGames: [Game] {
        guard let filter = filter else { return gamesCollection }
        return gamesCollection.filter(filter)
    }

    var filterLabels: [String] = [] {
        didSet {
            // Update the filter Container with the pills
        }
    }

    var filterLabel: String = "No Filters" {
        didSet {
            filterDescriptionView?.label.text = filterLabel
        }
    }

    class func keyPathsForValuesAffectingFilteredGames() -> Set<String> {
        return ["gamesCollection", "filters"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed_gamesVC", let destination = segue.destination as? GameTableViewController {
            gamesViewController = destination
            gamesViewController?.games = filteredGames
            gamesViewController?.delegate = self
        } else if segue.identifier == "filter", let destination = segue.destination as? FilterViewController {
            destination.delegate = self
            destination.configure(withFilterData: filterData)
        } else if segue.identifier == "game", let desitination = segue.destination as? GameViewController,
            let indexPath = sender as? IndexPath {
            desitination.game = gamesViewController?.games[indexPath.row]
        }
    }
}
