//
//  ViewController.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 6/14/19.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit
import Charts

/*
    Training
 
     1. Randomly initialize weights
     2. Forward propagation to get h(x) for any x
     3. Compute cost function J(Theta)
     4. Backpropagation to compute partial derivatives d/dTheta * J(Theta) (Compute D = D + delta(a))
     5. Gradient checking
     6. Gradient descent to minimize J(Theta) and find best Theta
 
    Prediction
 
    1. y = data * Theta
 
    Theta is matrix of weights.
 */

class ViewController: UIViewController {

    @IBOutlet var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GraphBuilder.configure(chartView: chartView)
        
        let traningData: [[Float]] = [ [0,0,0],
                                       [0,1,1],
                                       [1,0,1],
                                       [1,1,1] ]
        
        let traningResults: [[Float]] = [ [0], [0], [0], [1] ]
        
        // Training
        
        let network = NeuralNetwork(inputLayerSize: 3, hiddenLayerSize: 3, outputLayerSize: 1)
        
        for _ in 0..<NeuralNetwork.iterations {
            for i in 0..<traningResults.count {
                network.train(input: traningData[i], targetOutput: traningResults[i], learningRate: NeuralNetwork.learningRate, momentum: NeuralNetwork.momentum)
            }
            
            var sum: Float = 0.0
            for i in NeuralNetwork.currentError {
                sum += i
            }
            
            NeuralNetwork.averageError.append(sum / Float(NeuralNetwork.currentError.count))
            NeuralNetwork.currentError.removeAll()
        }
        
        // Prediction
        
        let testData: [[Float]] = [ [0.4, 0.1, 0.5],
                                    [0.1, 0.1, 0.5],
                                    [1.0, 0.9, 0.7],
                                    [0.0, 0.7, 0.1],
                                    [0.8, 0.7, 0.6] ]
        
        for i in 0..<testData.count {
            var t = testData[i]
            print("\(t[0]), \(t[1]), \(t[1])  -- \(network.run(input: t))")
        }
        
        print("finish")
        GraphBuilder.draw(chartView: chartView, data: NeuralNetwork.averageError)
    }
}

