//
//  BarChartYAxis.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 2/26/22.
//  Copyright © 2022 rlasante. All rights reserved.
//

import SwiftUI

struct BarChartYAxis: View {
    var width: CGFloat
    @Binding var labels: [BarChart.ChartData]

    var body: some View {
        GeometryReader { gr in
            let fullChartHeight = gr.size.height
            let maxTickHeight = fullChartHeight * 0.95
            let scaleFactor = maxTickHeight / CGFloat(labels.last?.value ?? 1)
            ZStack {
                // y-axis line
                Rectangle()
                    .fill(Color.black)
                    .frame(width:1.5)
                    .offset(x: (gr.size.width / 2.0) - 1, y: 1)
                ForEach(0 ..< labels.count, id: \.self) { i in
                    let tick = labels[i]
                    HStack {
                        Spacer()
                        Text(tick.label)
                            .font(.footnote)
                        Rectangle()
                            .frame(width: 10, height: 1)
                    }
                    .offset(
                        y: (fullChartHeight / 2) - CGFloat(tick.value) * scaleFactor
                    )
                }
            }
        }
        .frame(width: width)
    }
}

struct BarChartYAxis_Previews: PreviewProvider {
    @State private static var labels: [BarChart.ChartData] = [
        BarChart.ChartData(label: "2", value: 2),
        BarChart.ChartData(label: "5", value: 5),
        BarChart.ChartData(label: "10", value: 10),
        BarChart.ChartData(label: "100", value: 100)
    ]

    static var previews: some View {
        BarChartYAxis(width: 60, labels: $labels)
    }
}
