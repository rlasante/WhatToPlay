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

    @State var touchLocation: CGFloat = -1
    @Binding var currentLabel: String
    @Binding var yAxisLabels: [ChartData]
    @Binding var data: [ChartData]
    @Binding var selectedData: [ChartData]
    @Binding var highlightedData: [ChartData]

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
                        if !yAxisLabels.isEmpty {
                            BarChartYAxis(width: geometry.size.width * 0.2, labels: $yAxisLabels)
                        }
                        GeometryReader { geo in
                            HStack {
                                ForEach(0..<data.count, id: \.self) { i in
                                    BarChartCell(value: normalizedValue(index: i), barColor: self.finalBarColor(data[i]))
                                        .animation(.spring())
                                        .padding(.top)
                                }
                            }
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { position in
                                        let touchPosition = position.location.x / geo.frame(in: .local).width
                                        touchLocation = touchPosition
                                        updateCurrentValue()
                                    }
                                    .onEnded { _ in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            withAnimation(Animation.easeOut(duration: 0.5)) {
                                                resetValues()
                                            }
                                        }
                                    }
                            )
                        }
                    }

                    if currentLabel.isEmpty {
//                        Text(legend)
//                            .bold()
//                            .foregroundColor(.black)
//                            .padding(5)
//                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                    } else {
                        Text(currentLabel)
                            .bold()
                            .foregroundColor(.black)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                            .animation(.easeIn)
                    }
                }
                
            }
        }
        .padding()
    }

    private func finalBarColor(_ barData: ChartData) -> Color {
        let highlighting = !highlightedData.isEmpty
        let isHighlighted = highlightedData.contains(barData)
        let isSelected = selectedData.contains(barData)
        switch (highlighting, isHighlighted, isSelected) {
        case (true, true, _), (false, false, true):
            return selectedBarColor
        case (true, false, true):
            return selectedBarColor.opacity(0.5)
        case (_, false, false), (false, true, _):
            return barColor
        }
    }

    private func normalizedValue(index: Int) -> Double {
        let allValues: [Double] = data.map {
            $0.value
        }
        guard let max = allValues.max(), max != 0 else {
            return 1
        }
        return data[index].value / max
    }

    func updateCurrentValue() {
        let index = Int(touchLocation * CGFloat(data.count))
        guard index < data.count && index >= 0 else {
            highlightedData = []
            return
        }
        highlightedData = [data[index]]
    }

    func resetValues() {
        touchLocation = -1
        highlightedData  =  []
    }

    func labelOffset(in width: CGFloat) -> CGFloat {
        let currentIndex = Int(touchLocation * CGFloat(data.count))
        guard currentIndex < data.count && currentIndex >= 0 else {
            return 0
        }
        let cellWidth = width / CGFloat(data.count)
        let actualWidth = width - cellWidth
        let position = cellWidth * CGFloat(currentIndex) - actualWidth/2
        return position
    }
}


