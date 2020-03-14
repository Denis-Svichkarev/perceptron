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
    
    let trainingDataFileName = "Level 1" + ".txt"
    let testDataFileName     = "Level 1 test" + ".txt"
    
    let modelFileName        = "Level 1 weights" + ".txt"
    let networkStucture      = [2, 2, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GraphBuilder.configure(chartView: chartView)
        
        // MARK: - Initialization
        
        let network = NeuralNetwork(inputLayerSize: networkStucture[0], hiddenLayerSize: networkStucture[1], outputLayerSize: networkStucture[2])
                
        guard let trainingData = network.importTrainingData(name: trainingDataFileName) else {
            print("Could not load training data"); return
        }
            
        guard let testData = network.importTestData(name: testDataFileName) else {
            print("Could not load test data"); return
        }
        
        // MARK: - Training
        
        //network.run(input: trainingData.data, targetOutput: trainingData.results)
        network.importModel(name: modelFileName)
               
        // MARK: - Prediction
        
        print("Predictions:\n")
        
        let predictionsString = Log.getPredictionsString(network: network, data: testData)
        print(predictionsString)
        
        print("Finish")
        
        //network.exportModel()
        
        // MARK: - Drawing
        
        if network.averageErrors.count > 0 {
            GraphBuilder.draw(chartView: chartView, data: network.averageErrors)
        }
    }
}
