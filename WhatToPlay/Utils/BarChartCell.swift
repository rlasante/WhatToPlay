//
//  BarChartCell.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/6/22.
//  Copyright © 2022 rlasante. All rights reserved.
//

import Foundation
import SwiftUI

struct BarChartCell: View {

    var value: Double
    var barColor: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(barColor)
            .scaleEffect(CGSize(width: 1, height: value), anchor: .bottom)

    }
}

struct BarChartCell_Previews: PreviewProvider {
     static var previews: some View {
         BarChartCell(value: 3800, barColor: .blue)
             .previewLayout(.sizeThatFits)
     }
 }
