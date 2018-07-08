//
//  GameTableViewController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/23/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import AlamofireImage
import UIKit

class GameTableViewController: UITableViewController {

    weak var delegate: GameCollectionViewController?
    var games: [Game] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return games.isEmpty ? 1 : games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if games.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Loading Games"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
        cell.imageView?.af_cancelImageRequest()

        guard games.count > indexPath.row else { return cell }
        let game = games[indexPath.row]
        guard cell.textLabel?.text != game.name else { return cell }
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.text = game.detailText

        cell.imageView?.image = nil
        if let thumbnailURL = game.thumbnailURL {
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
            cell.imageView?.af_setImage(withURL: thumbnailURL) { response in
                guard response.response != nil else { return }
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard !games.isEmpty else { return nil }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.performSegue(withIdentifier: "game", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Game {
    var detailText: String {
        let duration: String
        if let minPlayingTime = minPlayingTime, let maxPlayingTime = maxPlayingTime, minPlayingTime != maxPlayingTime {
            duration = "\(Int(minPlayingTime / 60))-\(Int(maxPlayingTime / 60)) min"
        } else if let playingTime = playingTime {
            duration = "\(Int(playingTime / 60)) min"
        } else {
            duration = ""
        }
        return "\(playerCount.description), \(duration)"
    }
}

extension Array where Element == PlayerCount {
    var description: String {
        var description = ""
        for (index, playerCount) in self.enumerated() {
            switch playerCount {
            case .count(let value):
                description += "\(value)"
            case let .range(min, max):
                if min == max {
                    description += "\(min)"
                } else if max != Int.max {
                    description += "\(min)-\(max)"
                } else {
                    description += "\(min)+"
                }
            }
            if index < count - 1 {
                description += ", "
            }
        }
        return "\(description) players"
    }
}

