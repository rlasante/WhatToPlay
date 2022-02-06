//
//  BarChart.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/6/22.
//  Copyright © 2022 rlasante. All rights reserved.
//

import Foundation
import SwiftUI

struct BarChart: View {
    struct ChartData: Equatable {
        var label: String
        var value: Double
    }

    var title: String
//    var legend: String
    var barColor: Color
    var selectedBarColor: Color
    @Binding var data: [ChartData]
    @Binding var selectedData: [ChartData]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .font(.largeTitle)
//            Text("Current value: (currentValue)")
//                .font(.headline)
            GeometryReader { geometry in
                VStack {
                    HStack {
                        ForEach(0..<data.count, id: \.self) { i in
                            let isSelected = selectedData.contains(data[i])
                            let barColor = isSelected ? selectedBarColor : barColor
                            BarChartCell(value: normalizedValue(index: i), barColor: barColor)
                                .animation(.spring())
                                .padding(.top)
                        }
                    }
//                    if currentLabel.isEmpty {
//                        Text(legend)
//                            .bold()
//                            .foregroundColor(.black)
//                            .padding(5)
//                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
//                    } else {
//                        Text(currentLabel)
//                            .bold()
//                            .foregroundColor(.black)
//                            .padding(5)
//                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
//                            .animation(.easeIn)
//                    }
                }
                
            }
        }
        .padding()
    }

    private func normalizedValue(index: Int) -> Double {
        var allValues: [Double]    {
            var values = [Double]()
            for data in data {
                values.append(data.value)
            }
            return values
        }
        guard let max = allValues.max() else {
            return 1
        }
        if max != 0 {
            return Double(data[index].value)/Double(max)
        } else {
            return 1
        }
    }
}


