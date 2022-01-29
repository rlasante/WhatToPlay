//
//  CollectionPickerViewModel.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/17/19.
//  Copyright © 2019 rlasante. All rights reserved.
//

import Combine
import Foundation

/// API for fetching a list of collections
protocol CollectionListAPI {
    func collectionsSubject(username: String) -> AnyPublisher<[CollectionModel], Error>
}

/// API for fetching a list of collections
protocol CollectionListAPIAsync {
    func collections(username: String) async throws -> [CollectionModel]
}

extension CollectionListAPI where Self: CollectionListAPIAsync {
    func collectionsSubject(username: String) -> AnyPublisher<[CollectionModel], Error> {
        let subject = PassthroughSubject<[CollectionModel], Error>()
        Task {
            do {
                let models = try await collections(username: username)
                subject.send(models)
                subject.send(completion: .finished)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        return subject.eraseToAnyPublisher()
    }
}

enum CollectionSourceError: Error {
    case unableToConnect(CollectionSourceModel)
    case unknown
}

class CollectionPickerViewModel {
    private var cancelBag: Set<AnyCancellable> = []

    // MARK: - Inputs

    /// Calls to update the current source of the collection
    let source: PassthroughSubject<CollectionSourceModel, Never>

    /// Calls to update the current name of the collection
    let username: CurrentValueSubject<String?, Never>

    /// Calls to get named collection
    let collection: PassthroughSubject<CollectionModel, Error>

    /// Calls to reload collections
    let reload: PassthroughSubject<Void, Never>

    // MARK: - Outputs
    let sources: AnyPublisher<[CollectionSourceModel], Error>

    /// Emits an array of fetched repositories.
    let collections: AnyPublisher<[CollectionModel], Error>

    /// Emits a formatted title for a navigation item.
    let title: AnyPublisher<String, Never>

    /// Emits an error messages to be shown.
    let alertMessage: AnyPublisher<String, Never>

    /// Emits an collection to be shown.
    let showCollection: AnyPublisher<CollectionModel, Error>

    init() {
        // Reload collections
        reload = PassthroughSubject()

        // Emit sources
        sources = CurrentValueSubject([CollectionSourceModel.boardGameGeek, CollectionSourceModel.boardGameAtlas]).eraseToAnyPublisher()

        // Emit title
        title = CurrentValueSubject(NSLocalizedString("Collection Chooser", comment: "Collection picker Title")).eraseToAnyPublisher()

        // Receiving chosen Source
        source = PassthroughSubject()

        // Emit Alert messages
        let _alertMessageSubject = PassthroughSubject<String, Never>()
        alertMessage = _alertMessageSubject.eraseToAnyPublisher()

        let _collectionSubject = PassthroughSubject<CollectionModel, Error>()
        collection = _collectionSubject

        showCollection = _collectionSubject.eraseToAnyPublisher()

        self.username = CurrentValueSubject(nil)

        // Listen to changes in source then fetch the latest
        collections = Publishers.CombineLatest3(reload, source, self.username.debounce(for: .seconds(0.6), scheduler: DispatchQueue.main))
            .setFailureType(to: Error.self)
            .flatMap { latest -> AnyPublisher<[CollectionModel], Error> in
                guard let username = latest.2 else {
                    return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return latest.1.api().collectionsSubject(username: username)
        }.catch { error -> AnyPublisher<[CollectionModel], Error> in
            guard let sourceError = error as? CollectionSourceError else {
                print("Received error: \(error)")
                _alertMessageSubject.send(NSLocalizedString("Received unknown error while trying to connect to the site", comment: "Generic unknown collection source Error message"))
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            switch sourceError {
            case .unableToConnect(.boardGameGeek):
                _alertMessageSubject.send(NSLocalizedString("Unable to connect to Board Game Atlas at this time", comment: "Generic unable to connect to Board Game Geek Error message"))
            case .unableToConnect(.boardGameAtlas):
                _alertMessageSubject.send(NSLocalizedString("Unable to connect to Board Game Atlas at this time", comment: "Generic unable to connect to Board Game atlas Error message"))
            case .unableToConnect:
                print("Received unableToConnect: \(sourceError)")
                _alertMessageSubject.send(NSLocalizedString("Unable to connect to Source", comment: "Generic unknown collection source Error message"))
            default:
                print("Received sourceError: \(sourceError)")
                _alertMessageSubject.send(NSLocalizedString("Received unknown error while trying to connect to the site", comment: "Generic unknown collection source Error message"))
            }
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()

        // Listen to changes to collections. If only one in the list then mark as completion
        collections
            .filter {
                $0.count == 1
            }
            .compactMap {
                $0.first
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },  receiveValue: { [weak self] model in
                self?.collection.send(model)
            })
            .store(in: &cancelBag)
//            .subscribe(collection)

            // Listen to changes to collections. If only one in the list then mark as completion

//        .flatMap { collectionSource -> AnyPublisher<[CollectionModel], Never> in
//                collectionSource.catch { error -> AnyPublisher<[CollectionModel], Error> in
//                    guard let sourceError = error as? CollectionSourceError else {
//                        print("Received error: \(error)")
//                        _alertMessageSubject.send(NSLocalizedString("Received unknown error while trying to connect to the site", comment: "Generic unknown collection source Error message"))
//                        return Empty(completeImmediately: false).eraseToAnyPublisher()
//                    }
//                    switch sourceError {
//                    case .unableToConnect(.boardGameGeek):
//                        _alertMessageSubject.send(NSLocalizedString("Unable to connect to Board Game Atlas at this time", comment: "Generic unable to connect to Board Game Geek Error message"))
//                    case .unableToConnect(.boardGameAtlas):
//                        _alertMessageSubject.send(NSLocalizedString("Unable to connect to Board Game Atlas at this time", comment: "Generic unable to connect to Board Game atlas Error message"))
//                    case .unableToConnect:
//                        print("Received unableToConnect: \(sourceError)")
//                        _alertMessageSubject.send(NSLocalizedString("Unable to connect to Source", comment: "Generic unknown collection source Error message"))
//                    default:
//                        print("Received sourceError: \(sourceError)")
//                        _alertMessageSubject.send(NSLocalizedString("Received unknown error while trying to connect to the site", comment: "Generic unknown collection source Error message"))
//                    }
//                    return Empty(completeImmediately: false).eraseToAnyPublisher()
//                }
//            }
//            .eraseToAnyPublisher()
//        .catch { error in
//                guard let sourceError = error as? CollectionSourceError else {
//                    print("Received error: \(error)")
//                    _alertMessageSubject.send(NSLocalizedString("Received unknown error while trying to connect to the site", comment: "Generic unknown collection source Error message"))
//                    return Empty()
//                }
//                switch sourceError {
//                case .unableToConnect(.boardGameGeek):
//                    _alertMessageSubject.send(NSLocalizedString("Unable to connect to Board Game Atlas at this time", comment: "Generic unable to connect to Board Game Geek Error message"))
//                case .unableToConnect(.boardGameAtlas):
//                    _alertMessageSubject.send(NSLocalizedString("Unable to connect to Board Game Atlas at this time", comment: "Generic unable to connect to Board Game atlas Error message"))
//                case .unableToConnect:
//                    print("Received unableToConnect: \(sourceError)")
//                    _alertMessageSubject.send(NSLocalizedString("Unable to connect to Source", comment: "Generic unknown collection source Error message"))
//                default:
//                    print("Received sourceError: \(sourceError)")
//                    _alertMessageSubject.send(NSLocalizedString("Received unknown error while trying to connect to the site", comment: "Generic unknown collection source Error message"))
//                }
//                return Empty()
//        }
    }
}
