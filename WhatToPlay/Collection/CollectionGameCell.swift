//
//  CollectionGameCell.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/21/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import CoreData
import SDWebImageSwiftUI
import SwiftUI

struct CollectionGameCell: View {
    @State var game: Game
    @Binding var selectedGame: Game?
    var body: some View {
        HStack {
            WebImage(url: game.thumbnailURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 60, idealHeight: 44, maxHeight: 60, alignment: .center)
            VStack(alignment: .leading) {
                Text(game.name!)
                Text(game.detailText)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.accentColor)
            }
            Spacer()
        }.onTapGesture {
            print("Cell Tapped \(self.game.id)")
            self.selectedGame = self.game
        }
    }
}
