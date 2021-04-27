//
//  CollectionView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/18/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import CoreData
import SwiftUI

struct CollectionView: View {
    @ObservedObject var viewModel: CollectionViewModel
//    @State var selectedGame: Game? = nil

    var body: some View {
        List(viewModel.games) { game in
            CollectionGameCell(game: game)
                .background(Color.white) // don't know why it
                .onTapGesture {
                    self.viewModel.selectedGame = game
                }
        }
//        ScrollView {
//            ForEach(viewModel.games) { game in
//                CollectionGameCell(game: game)
//                .contentShape(Rectangle())
//                    .onTapGesture {
//                        print("tapped \(game.id)")
//                        //                            self.selectedGame = game
//                        self.viewModel.selectedGame = game
//                }
//
//            }
//        }
        .navigationBarTitle(Text("Collection (\(viewModel.games.count))"))
            .navigationBarItems(trailing: Button("Filters") { self.viewModel.selectFilters.send(()) })
    }
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//    }
//}
