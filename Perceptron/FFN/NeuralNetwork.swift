//
//  Network.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

//let weights1: [Float] = [-0.5409913, -1.7990237, -1.3129711, 1.0503097, -0.69597864, -1.0141525, 1.9999089, 1.1245115, 1.1535337, -1.1223313, 0.6454177, 0.322474]
//let weights2: [Float] = [-1.6887815, 0.0869894, 1.0824788, 0.31791997]

class NeuralNetwork: NSObject {

    var layers: [Layer] = []
    var weights: [[Weight]] = []
    
    var errors: [Float] = []            // array of errors of the neurons output per an iteration
    var averageErrors: [Float] = []     // array of average errors per N iterations
    
    static var iterations: Int = 1000
    static var learningRate: Float = 0.3
    static var momentum: Float = 1
    
    // MARK: - Algorithm
    
    init(inputLayerSize: Int, hiddenLayerSize: Int, outputLayerSize: Int) {
        
        layers.append(Layer(layerType: .input, index: 1, count: 3, bias: true))
        layers.append(Layer(layerType: .hidden, index: 2, count: 3, bias: true))
        layers.append(Layer(layerType: .output, index: 3, count: 1, bias: false))
        
//        let w1: [Float] = (0..<(inputLayerSize + 1) * hiddenLayerSize).map { _ in
//            return (-2.0...2.0).random()
//        }
//
//        let w2: [Float] = (0..<(hiddenLayerSize + 1) * outputLayerSize).map { _ in
//            return (-2.0...2.0).random()
//        }

        var w1 = [Weight]()
        var w2 = [Weight]()
        
        for _ in 0..<(inputLayerSize + 1) * hiddenLayerSize {
            //w1.append(Weight(w: weights1[i]))
            w1.append(Weight(w: (-2.0...2.0).random()))
        }
        
        for _ in 0..<(hiddenLayerSize + 1) * outputLayerSize {
            //w2.append(Weight(w: weights2[i]))
            w2.append(Weight(w: (-2.0...2.0).random()))
        }
        
        weights.append(w1)
        weights.append(w2)
        
        for i in 0..<layers.count - 1 {
            let count = (layers[i + 1].layerType == .output) ? 1 : layers[i + 1].neurons.count - 1
            for i2 in 0..<count {
                for i3 in 0..<layers[i].neurons.count {
                    weights[i][i3 + i2 * layers[i].neurons.count].prev = layers[i].neurons[i3]
                    weights[i][i3 + i2 * layers[i].neurons.count].next = layers[i + 1].neurons[i2]
                }
            }
        }
        
//        for i in 0..<weights.count {
//            for i2 in 0..<weights[i].count {
//                weights[i][i2].log()
//            }
//        }
    }
    
    func run(input: [[Float]], targetOutput: [[Float]]) {
        for _ in 0..<NeuralNetwork.iterations {
            for i in 0..<targetOutput.count {
                errors.append(forward(input: input[i], targetOutput: targetOutput[i]))
                backprop()
            }
            
            //print("\(weights.last![0].w) : \(weights.last![1].w) : \(weights.last![2].w) : \(weights.last![3].w)")
            addAverageError()
            errors.removeAll()
        }
    }
    
    func forward(input: [Float], targetOutput: [Float]?) -> Float {
        
        for i in 0..<input.count {
            weights[0][i].prev.x = input[i]
        }
        
        weights.last!.last!.prev.x = 1
        
        for L in 0..<layers.count - 1 {
            layers[L].neurons.last!.x = 1
            let count = (layers[L + 1].layerType == .output) ? 1 : layers[L + 1].neurons.count - 1
            
            for i in 0..<count {
                var sum: Float = 0.0
                
                for j in 0..<weights[L].count {
                    if weights[L][j].next == layers[L + 1].neurons[i] {
                        sum += weights[L][j].w * weights[L][j].prev.x
                    }
                }
                
                let a = ActivationFunction.sigmoid(x: sum)
                layers[L + 1].neurons[i].x = a
            }
        }
        
        if let targetOutput = targetOutput {
            let error = targetOutput[0] - weights.last![0].next.x
            weights.last![0].next.error = error
            return error
            
        } else {
            return weights.last![0].next.x
        }
    }
    
    func backprop() {
        
        var L = layers.count - 2
        
        while true {
            for i in 0..<weights[L].count {
                var error: Float = 0.0
                let g = ActivationFunction.sigmoidDerivative(x: weights[L][i].next.x)
                
                for j in 0..<weights[L].count {
                    if weights[L][i].prev == weights[L][j].prev {
                        error += weights[L][j].w * weights[L][j].next.error * g
                    }
                }
                
                weights[L][i].prev.error = error
    
                let delta = weights[L][i].prev.x * weights[L][i].next.error
                weights[L][i].w = weights[L][i].w * NeuralNetwork.momentum + (NeuralNetwork.learningRate * delta * g)
            }
            
            L -= 1
            
            if L < 0 { break }
        }
    }

    // MARK: - Model
    
    func importModel() {
        
    }
    
    func exportModel() {
        
    }
    
    // MARK: - Helpers
    
    private func addAverageError() {
        var sum: Float = 0.0
        
        for error in errors {
            sum += error
        }
        
        averageErrors.append(sum / Float(errors.count))
    }
}