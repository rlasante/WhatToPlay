//
//  FilterCollectionViewController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/7/18.
//  Copyright © 2018 rlasante. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FilterCell"
private let noFilterIdentifier = "NoFilterCell"

class FilterCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var filterLabels: [String] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    var haveFilters: Bool { return !filterLabels.isEmpty }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return haveFilters ? filterLabels.count : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard haveFilters else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noFilterIdentifier, for: indexPath) as! MiniFilterViewCell
            cell.label.text = NSLocalizedString("No Filters", comment: "")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MiniFilterViewCell
    
        // Configure the cell
        cell.label.text = filterLabels[indexPath.row]
    
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MiniFilterViewCell

        // Configure the cell
        let font = UIFont.systemFont(ofSize: 17)

        let description = (haveFilters ? filterLabels[indexPath.row] : NSLocalizedString("No Filters", comment: "")) as NSString
        let size = description.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 25),
                                 options: [.usesLineFragmentOrigin],
                                 attributes: [.font: font],
                                 context: nil)
        let newWidth = CGFloat(Int(size.width) + 20)
        return CGSize(width: newWidth, height: 25)
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
