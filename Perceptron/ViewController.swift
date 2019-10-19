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
            
        GraphBuilder.configure(chartView: chartView)
        
        // MARK: - Initialization
        
        let network = NeuralNetwork(inputLayerSize: 3, hiddenLayerSize: 3, outputLayerSize: 1)

        //        let traningData: [[Float]] = [ [0,0,0],
        //                                       [0,1,1],
        //                                       [1,0,1],
        //                                       [1,1,1] ]
        //
        //        let traningResults: [[Float]] = [ [0], [0], [0], [1] ]
                
        guard let trainingData = network.importTrainingData(name: "training ex1.txt") else {
            print("Could not load training data")
            return
        }
        
        //        let testData: [[Float]] = [ [0.4, 0.1, 0.5],
        //                                    [0.1, 0.1, 0.5],
        //                                    [1.0, 0.9, 0.7],
        //                                    [0.0, 0.7, 0.1],
        //                                    [0.8, 0.7, 0.6] ]
            
        guard let testData = network.importTestData(name: "test ex1.txt") else {
            print("Could not load test data")
            return
        }
        
        // MARK: - Training
        
        //network.run(input: traningData, targetOutput: traningResults)

        network.run(input: trainingData.data, targetOutput: trainingData.results)
        
        //network.importModel(name: "weights 20-48-24 18.10.19.txt")
               
        // MARK: - Prediction
        
        print("Predictions:\n")
        
        let predictionsString = Log.getPredictionsString(network: network, data: testData)
        print(predictionsString)
        
        print("Finish")
        
        //network.exportModel()
        
        GraphBuilder.draw(chartView: chartView, data: network.averageErrors)
    }
}
