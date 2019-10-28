//
//  GraphBuilder.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 30/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit
import Charts

class GraphBuilder: NSObject {

    static func configure(chartView: LineChartView) {
        //chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
//        // x-axis limit line
//        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
//        llXAxis.lineWidth = 4
//        llXAxis.lineDashLengths = [10, 10, 0]
//        llXAxis.labelPosition = .bottomRight
//        llXAxis.valueFont = .systemFont(ofSize: 10)
//
//        chartView.xAxis.gridLineDashLengths = [10, 10]
//        chartView.xAxis.gridLineDashPhase = 0
//
//        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
//        ll1.lineWidth = 4
//        ll1.lineDashLengths = [5, 5]
//        ll1.labelPosition = .topRight
//        ll1.valueFont = .systemFont(ofSize: 10)
//
//        let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
//        ll2.lineWidth = 4
//        ll2.lineDashLengths = [5,5]
//        ll2.labelPosition = .bottomRight
//        ll2.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        //leftAxis.removeAllLimitLines()
        //leftAxis.addLimitLine(ll1)
        //leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = -100
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        
        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
        
        chartView.legend.form = .line
        chartView.animate(xAxisDuration: 2.5)
    }
    
    static func draw(chartView: LineChartView, data: [[Float]]) {
        //        let values = (0..<count).map { (i) -> ChartDataEntry in
        //            let val = (-2.0...2.0).random()
        //            return ChartDataEntry(x: Double(i), y: val, icon: nil)
        //        }
        
        var values = [ChartDataEntry]()
        
        for (index, i) in data.enumerated() {
            //print("\(i[0]):\(i[1])\n")
            var sum: Float = 0
            
            for j in i {
                sum += abs(j)
            }
            
            sum /= Float(i.count)
            
            values.append(ChartDataEntry(x: Double(index), y: Double(sum * 100), icon: nil))
        }
        
        let set1 = LineChartDataSet(entries: values, label: "DataSet 1 (x100)")
        set1.drawIconsEnabled = false
        
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 1
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
//        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
//                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//        set1.fillAlpha = 1
//        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
}
