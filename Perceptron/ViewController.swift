//
//  ViewController.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 6/14/19.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        for i in 0..<100 {
//            //let c = Double.random(in: 0...100)
//            let x = Double.random(in: 1...2)
//            let y = pow(x, 3)
//            print("\(i + 1)) \(round(100 * y)/100)")
//        }
//        
//        return
        
        GraphBuilder.configure(chartView: chartView)
        
//        let traningData: [[Float]] = [ [0,0,0],
//                                       [0,1,1],
//                                       [1,0,1],
//                                       [1,1,1] ]
//
//        let traningResults: [[Float]] = [ [0], [0], [0], [1] ]
        
        // Training
        
        let network = NeuralNetwork(inputLayerSize: 3, hiddenLayerSize: 3, outputLayerSize: 1)

        network.importModel(name: "weights 20-48-24 18.10.19.txt")
        
        //network.run(input: traningData, targetOutput: traningResults)

        // Prediction
        
        let testData: [[Float]] = [ [0.4, 0.1, 0.5],
                                    [0.1, 0.1, 0.5],
                                    [1.0, 0.9, 0.7],
                                    [0.0, 0.7, 0.1],
                                    [0.8, 0.7, 0.6] ]
        
        for i in 0..<testData.count {
            let x = testData[i]
            print("\(x[0]), \(x[1]), \(x[1])  -- \(network.forward(input: x, targetOutput: nil))")
        }
        
        print("finish")
        
        //network.exportModel()
        
        GraphBuilder.draw(chartView: chartView, data: network.averageErrors)
    }
}
