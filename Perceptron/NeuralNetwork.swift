//
//  Network.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class NeuralNetwork: NSObject {

    var inputLayerSize: Int = 0
    var hiddenLayerSize: Int = 0
    var outputLayerSize: Int = 0
    
    var w1: Matrix<Double>?
    var w2: Matrix<Double>?

    var z2: Matrix<Double>?
    var a2: Matrix<Double>?
    var z3: Matrix<Double>?
    var a3: Matrix<Double>?
    
    init(inputLayerSize: Int, outputLayerSize: Int, hiddenLayerSize: Int) {
        self.inputLayerSize = inputLayerSize
        self.outputLayerSize = outputLayerSize
        self.hiddenLayerSize = hiddenLayerSize

        w1 = rand(width: hiddenLayerSize, inputLayerSize)
        w2 = rand(width: outputLayerSize, hiddenLayerSize)
    }
    
    func forward(x: Matrix<Double>) -> Matrix<Double>? {
        guard let w1 = w1, let w2 = w2 else {
            return nil
        }
        
        // Propagate inputs through first layer
        z2 = x * w1′
        
        // Apply activation function
        a2 = sigmoid(z: z2!)
        
        // Propagate values through third layer
        z3 = a2! * w2′
        
        // Apply activation function
        a3 = sigmoid(z: z3!)
        
        return a3
    }
}

func randd() -> Double {
    return Double(arc4random()) / Double(RAND_MAX)
}

func sigmoid(z: Double) -> Double {
    return 1.0 / (1.0 + exp(-z))
}

func rand(width: Int, _ height: Int) -> Matrix<Double> {
    var result = Matrix(repeating: 0, rows: width, columns: height)
    for i in 0..<result.rows {
        for j in 0..<result.columns {
            result[i, j] = randd()
        }
    }
    return result
}

func sigmoid(z: Matrix<Double>) -> Matrix<Double> {
    var m = Matrix(repeating: 0, rows: z.rows, columns: z.columns)
    for i in 0..<z.rows {
        for j in 0..<z.columns {
            m[i, j] = sigmoid(z: z[i, j])
        }
    }
    return m
}
