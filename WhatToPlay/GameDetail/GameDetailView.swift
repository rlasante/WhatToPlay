//
//  GameDetailView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/21/20.
//  Copyright © 2020 rlasante. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

struct GameDetailView: View {
    @ObservedObject var viewModel: GameDetailViewModel
    var body: some View {
        let gradient = Gradient(stops: [.init(color: .white, location: 0.75), .init(color: .clear, location: 1.0)])

        return GeometryReader { geometry in
            ScrollView {
                VStack {
                    ZStack {
                        WebImage(url: self.viewModel.game.imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height / 3, alignment: .top)
                            .clipped()
                            .mask(
                                LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
                                    .frame(width: geometry.size.width, height: geometry.size.height / 3, alignment: .top)
                                    .clipped()
                            )
                    }

                    Text(self.viewModel.game.playerCount.description)
                    Text("Suggested: \(self.viewModel.game.suggestedPlayerCount.description)")
                    Text("Best: \([self.viewModel.game.bestPlayerCount!].description)")
                    Text("Description: \(self.viewModel.game.gameDescription!.replacingHtmlEntities)")
                        .padding(20)
                    Spacer()
                }.navigationBarTitle(Text(self.viewModel.game.name!))
            }
        }
    }
}
