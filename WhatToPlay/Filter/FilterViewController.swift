//
//  FilterViewController.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/23/17.
//  Copyright © 2017 rlasante. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    var filter: ((Game)->Bool)? { get set }
    var filterData: [String: Any] { get set }
    var filterLabel: String { get set }
    var filterLabels: [String] { get set }
}

enum FilterType: String {
    case playerCount
    case suggestedPlayerCount
    case bestPlayerCount
    case category
    case mechanic
    case minPlayTime
    case maxPlayTime
    case complexity
}

class FilterViewController: UITableViewController {

    var filters: [(FilterTemplate.Type, FilterTemplate?)] = [
        (PlayerCountFilter.self, nil),
        (ComplexityFilter.self, nil),
        (PlayDurationFilter.self, nil),
        (GameMechanicFilter.self, nil),
        (GameCategoryFilter.self, nil)
    ]

    func setFilter(_ filter: FilterTemplate) {
        let filterType = type(of: filter)
        if let filterIndex = filters.index(where: { $0.0 == filterType }) {
            filters[filterIndex] = (filterType, filter)
        } else {
            filters.append((filterType, filter))
        }
    }

    func clearFilters(_ filterTypes: FilterTemplate.Type...) {
        clearFilters(filterTypes)
    }

    func clearFilters(_ filterTypes: [FilterTemplate.Type]) {
        for type in filterTypes {
            if let filterIndex = filters.index(where: { $0.0 == type }) {
                filters[filterIndex] = (type, nil)
            } else {
                filters.append((type, nil))
            }
        }
    }

    var data: [[FilterType]] = [
        [
            .playerCount,
            .suggestedPlayerCount,
            .bestPlayerCount
        ],
        [
            .complexity
        ],
        [
            .minPlayTime,
            .maxPlayTime
        ],
        [
            .mechanic
        ],
        [
            .category
        ]
        ]

    var playerCountController = PlayerCountController()
    var categoryController = PickerController(data: [GameCategory.allValues])
    var mechanicController = PickerController(data: [GameMechanic.allValues])

    var minPlayTimeController = PickerController(data: [[Int](0...32).map { $0 * 15 }])
    var maxPlayTimeController = PickerController(data: [[Int](0...32).map { $0 * 15 }])
    var complexityController = PickerController(data: [GameComplexity.all])

    var playerCount: PlayerCount? {
        get { return playerCountController.playerCount }
        set { playerCountController.playerCount = newValue }
    }

    var suggestedPlayerCountOnly = false {
        didSet {
            if let path = indexPath(for: .suggestedPlayerCount) {
                tableView.reloadRows(at: [path], with: .fade)
            }
        }
    }
    var bestPlayerCountOnly = false {
        didSet {
            if let path = indexPath(for: .bestPlayerCount) {
                tableView.reloadRows(at: [path], with: .fade)
            }
        }
    }

    weak var delegate: FilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back(sender:)))
        let clearFiltersButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(onClearFiltersButton))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.rightBarButtonItem = clearFiltersButton

    }

    func configure(withFilterData filterData: [String: Any]) {
        filters = filters.map { (filterType, filter) -> (FilterTemplate.Type, FilterTemplate?) in
            let dataKey = String(describing: filterType)
            return (filterType, filterType.init(filterData: filterData[dataKey] as? [String: Any]))
        }

        for (type, filter) in filters {
            switch (type, filter) {
            case (is PlayerCountFilter.Type, let filteredPlayer as PlayerCountFilter?):
                playerCount = filteredPlayer?.playerCount
                suggestedPlayerCountOnly = filteredPlayer?.suggestedPlayerCountOnly ?? false
                bestPlayerCountOnly = filteredPlayer?.bestPlayerCountOnly ?? false
            case (is GameCategoryFilter.Type, let filteredCategory as GameCategoryFilter?):
                // TODO make this so we can select multiple categories
                categoryController.selectedData = [filteredCategory?.categories.first]
            case (is GameMechanicFilter.Type, let filteredMechanic as GameMechanicFilter?):
                // TODO make this so we can select multiple mechanics
                mechanicController.selectedData = [filteredMechanic?.mechanics.first]
            case (is PlayDurationFilter.Type, let playDurationFilter as PlayDurationFilter?):
                // TODO make this so we can select multiple mechanics
                guard let playDurationFilter = playDurationFilter else { continue }
                minPlayTimeController.selectedData = [Int(playDurationFilter.duration.lowerBound / 60)]
                maxPlayTimeController.selectedData = [Int(playDurationFilter.duration.upperBound / 60)]

            case (is ComplexityFilter.Type, let complexityFilter as ComplexityFilter?):
                guard let complexityFilter = complexityFilter else { continue }
                complexityController.selectedData = [complexityFilter.desiredComplexity]

            default:
                assertionFailure("No such filter supported")

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data[section].count
    }

    @IBAction func onClearFiltersButton() {
        clearFilters(filters.map { $0.0 })
        delegate?.filter = nil
        delegate?.filterData = [:]
        delegate?.filterLabel = "No Filters"
        delegate?.filterLabels = []
        navigationController?.popViewController(animated: true)
    }

    @IBAction func back(sender: UIBarButtonItem) {
        defer {
            navigationController?.popViewController(animated: true)
        }

        if let filteredPlayerCount = playerCountController.playerCount, let playerFilter = PlayerCountFilter(playerCount: filteredPlayerCount, suggestedPlayerCountOnly: suggestedPlayerCountOnly, bestPlayerCountOnly: bestPlayerCountOnly) {
            setFilter(playerFilter)
        } else {
            clearFilters(PlayerCountFilter.self)
        }

        if let categoryOpt = categoryController.selectedData.first,
            let category = categoryOpt,
            let filter = GameCategoryFilter(categories: category) {
            setFilter(filter)
        } else {
            clearFilters(GameCategoryFilter.self)
        }

        // TODO fix this to work with multiple mechanics
        if let mechanicOpt = mechanicController.selectedData.first,
            let mechanic = mechanicOpt,
            let filter = GameMechanicFilter(mechanics: mechanic) {
            setFilter(filter)
        } else {
            clearFilters(GameMechanicFilter.self)
        }

        if let minPlayTimeOpt = minPlayTimeController.selectedData.first,
            let maxPlayTimeOpt = maxPlayTimeController.selectedData.first,
            let minPlayTime = minPlayTimeOpt,
            let maxPlayTime = maxPlayTimeOpt {
            setFilter(PlayDurationFilter(duration: Range<TimeInterval>(uncheckedBounds: (TimeInterval(minPlayTime * 60), TimeInterval(maxPlayTime * 60)))))
        } else {
            clearFilters(PlayDurationFilter.self)
        }

        if let complexityOpt = complexityController.selectedData.first, let complexity = complexityOpt {
            setFilter(ComplexityFilter(complexity: complexity))
        } else {
            clearFilters(ComplexityFilter.self)
        }

        let enabledFilters = filters.compactMap { $0.1 }

        delegate?.filter = { game in
            // find first one that returns false, if none return false then its true
            return !enabledFilters.contains(where: { !($0.isValid(game)) })
        }

        delegate?.filterData = enabledFilters.reduce([String: Any]()) { result, filter in
            var newResult = result
            newResult[String(describing: type(of: filter))] = filter.serialize()
            return newResult
        }
        updateFilterLabels(filters: enabledFilters)
    }

    private func updateFilterLabels(filters: [FilterTemplate]) {
        let filterLabels = filters.map { filters.count < 3 ? $0.description : $0.shortDescription }
        var filterLabel = filterLabels.joined(separator: "; ")
        if filterLabel.isEmpty { filterLabel = "No Filters" }
        delegate?.filterLabel = filterLabel
        delegate?.filterLabels = filters.flatMap { $0.descriptions }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = filterType(for: indexPath)
        let pickerControllers: [FilterType: Any] = [
            .playerCount: playerCountController,
            .category: categoryController,
            .mechanic: mechanicController,
            .minPlayTime: minPlayTimeController,
            .maxPlayTime: maxPlayTimeController,
            .complexity: complexityController
        ]

        switch cellType {
        case .playerCount, .category, .mechanic, .minPlayTime, .maxPlayTime, .complexity:
            let cell: PickerTableViewCell = tableViewCell(for: indexPath)
            let delegate: UIPickerViewDelegate = pickerControllers[cellType] as! UIPickerViewDelegate
            let datasource: UIPickerViewDataSource = pickerControllers[cellType] as! UIPickerViewDataSource
            var listener: UIPickerViewListener = pickerControllers[cellType] as! UIPickerViewListener

            cell.picker.delegate = delegate
            cell.picker.dataSource = datasource
            listener.pickerView = cell.picker

            return cell
        case .suggestedPlayerCount:
            let cell: UITableViewCell = tableViewCell(for: indexPath)
            cell.accessoryType = (suggestedPlayerCountOnly) ? .checkmark : .none
            return cell
        case .bestPlayerCount:
            let cell: UITableViewCell = tableViewCell(for: indexPath)
            cell.accessoryType = (bestPlayerCountOnly) ? .checkmark : .none
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch filterType(for: indexPath) {
        case .playerCount, .category, .mechanic, .complexity, .minPlayTime, .maxPlayTime:
            return
        case .suggestedPlayerCount:
            suggestedPlayerCountOnly = !suggestedPlayerCountOnly
            if suggestedPlayerCountOnly { bestPlayerCountOnly = false }
        case .bestPlayerCount:
            bestPlayerCountOnly = !bestPlayerCountOnly
            if bestPlayerCountOnly { suggestedPlayerCountOnly = false }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch filterType(for: indexPath) {
        case .playerCount, .minPlayTime, .maxPlayTime, .complexity:
            return 99
        case .category, .mechanic:
            return 150
        default:
            return 44
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func indexPath(for filterType: FilterType) -> IndexPath? {
        for (section, filterTypes) in data.enumerated() {
            for (row, possibleFilterType) in filterTypes.enumerated() {
                if possibleFilterType == filterType {
                    return IndexPath(row: row, section: section)
                }
            }
        }
        return nil
    }

    func filterType(for indexPath: IndexPath) -> FilterType {
        return data[indexPath.section][indexPath.row]
    }

    func tableViewCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: filterType(for: indexPath).rawValue) as? T else { return T() }
        return cell
    }

}
