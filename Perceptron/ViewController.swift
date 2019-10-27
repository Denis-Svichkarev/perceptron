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
                
        guard let trainingData = network.importTrainingData(name: "training ex2.txt") else {
            print("Could not load training data")
            return
        }
            
        guard let testData = network.importTestData(name: "test ex2.txt") else {
            print("Could not load test data")
            return
        }
        
        // MARK: - Training
        
        network.run(input: trainingData.data, targetOutput: trainingData.results)
        
        //network.importModel(name: "weights 27.10.19 21-42-29.txt")
               
        // MARK: - Prediction
        
        print("Predictions:\n")
        
        let predictionsString = Log.getPredictionsString(network: network, data: testData)
        print(predictionsString)
        
        print("Finish")
        
        //network.exportModel()
        
        if network.averageErrors.count > 0 {
            GraphBuilder.draw(chartView: chartView, data: network.averageErrors)
        }
    }
}
