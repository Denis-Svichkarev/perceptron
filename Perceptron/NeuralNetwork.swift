//
//  Network.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class NeuralNetwork: NSObject {

    public static var learningRate: Float = 0.3
    public static var momentum: Float = 1
    public static var iterations: Int = 1000
    public static var currentError = [Float]()
    public static var averageError = [Float]()
    private var layers: [Layer] = []
    
    init(inputLayerSize: Int, hiddenLayerSize: Int, outputLayerSize: Int) {
        self.layers.append(Layer(inputSize: inputLayerSize, outputSize: hiddenLayerSize))
        self.layers.append(Layer(inputSize: hiddenLayerSize, outputSize: outputLayerSize))
    }
    
    public func run(input: [Float]) -> [Float] {
     
        var activations = input
        
        for i in 0..<layers.count {
            activations = layers[i].run(inputArray: activations)
        }
        
        return activations
    }
    
    public func train(input: [Float], targetOutput: [Float], learningRate: Float, momentum: Float) {
        
        let calculatedOutput = run(input: input)
        
        var error = zip(targetOutput, calculatedOutput).map { $0 - $1 }
        NeuralNetwork.currentError.append(error[0])
        
        for i in (0...layers.count - 1).reversed() { // идем в обратном направлении и с каждым левым слоем получаем ошибки правого, обрабатываем и передаем дальше левым
            error = layers[i].train(error: error, learningRate: learningRate, momentum: momentum)
        }
    }
}

//func randd() -> Double {
//    return Double(arc4random()) / Double(RAND_MAX)
//}

//func sigmoid(z: Double) -> Double {
//    return 1.0 / (1.0 + exp(-z))
//}

//func rand(width: Int, _ height: Int) -> Matrix<Double> {
//    var result = Matrix(repeating: 0, rows: width, columns: height)
//    for i in 0..<result.rows {
//        for j in 0..<result.columns {
//            result[i, j] = randd()
//        }
//    }
//    return result
//}
//
//func sigmoid(z: Matrix<Double>) -> Matrix<Double> {
//    var m = Matrix(repeating: 0, rows: z.rows, columns: z.columns)
//    for i in 0..<z.rows {
//        for j in 0..<z.columns {
//            m[i, j] = sigmoid(z: z[i, j])
//        }
//    }
//    return m
//}
