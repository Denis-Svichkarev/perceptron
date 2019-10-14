//
//  Network.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

public extension ClosedRange where Bound: FloatingPoint {
    public func random() -> Bound {
        let range = self.upperBound - self.lowerBound
        let randomValue = (Bound(arc4random_uniform(UINT32_MAX)) / Bound(UINT32_MAX)) * range + self.lowerBound
        return randomValue
    }
}

let weights1: [Float] = [-0.5409913, -1.7990237, -1.3129711, 1.0503097, -0.69597864, -1.0141525, 1.9999089, 1.1245115, 1.1535337, -1.1223313, 0.6454177, 0.322474]
let weights2: [Float] = [-1.6887815, 0.0869894, 1.0824788, 0.31791997]

class NeuralNetwork: NSObject {

//    public static var learningRate: Float = 0.3
//    public static var momentum: Float = 1
//    public static var iterations: Int = 1000
//    public static var currentError = [Float]()
//    public static var averageError = [Float]()
    
    var layers: [Layer] = []
    var weights: [[Weight]] = []
    
    var errors: [Float] = []            // array of errors of the neurons output per an iteration
    var averageErrors: [Float] = []     // array of average errors per N iterations
    
    static var iterations: Int = 10000
    static var learningRate: Float = 0.3
    
    var inputLayerSize: Int = 0
    var hiddenLayerSize: Int = 0
    var outputLayerSize: Int = 0
    
    // MARK: - Algorithm
    
    init(inputLayerSize: Int, hiddenLayerSize: Int, outputLayerSize: Int) {
        
        self.inputLayerSize = inputLayerSize
        self.hiddenLayerSize = hiddenLayerSize
        self.outputLayerSize = outputLayerSize
        
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
        
        for i in 0..<(inputLayerSize + 1) * hiddenLayerSize {
            w1.append(Weight(w: weights1[i]))
        }
        
        for i in 0..<(hiddenLayerSize + 1) * outputLayerSize {
            w2.append(Weight(w: weights2[i]))
        }
        
        weights.append(w1)
        weights.append(w2)
        
        for i in 0..<layers.count - 1 {
            let count = (layers[i + 1].layerType == .output) ? 1 : layers[i + 1].neurons.count - 1
            for i2 in 0..<count {
                for i3 in 0..<layers[i].neurons.count {
                    weights[i][i3 + i2 * layers[i].neurons.count].x = layers[i].neurons[i3]
                    weights[i][i3 + i2 * layers[i].neurons.count].y = layers[i + 1].neurons[i2]
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
            weights[0][i].x.x = input[i]
        }
        
        weights[1].last!.x.x = 1
        
        for L in 0..<layers.count - 1 {
            layers[L].neurons.last!.x = 1
            let count = (layers[L + 1].layerType == .output) ? 1 : layers[L + 1].neurons.count - 1
            
            for i in 0..<count {
                var sum: Float = 0.0
                
                for j in 0..<weights[L].count {
                    if weights[L][j].y == layers[L + 1].neurons[i] {
                        sum += weights[L][j].w * weights[L][j].x.x
                    }
                }
                
                let a = ActivationFunction.sigmoid(x: sum)
                layers[L + 1].neurons[i].x = a
            }
        }
        
        if let targetOutput = targetOutput {
            let error = targetOutput[0] - weights.last![0].y.x
            weights.last![0].y.error = error
            return error
            
        } else {
            return weights.last![0].y.x
        }
    }
    
    func backprop() {
        
        var L = layers.count - 2
        
        while true {
            //let count = (layers[L + 1].layerType == .output) ? 1 : layers[L + 1].neurons.count - 1
            
            for i in 0..<weights[L].count {
                var error: Float = 0.0
                let g = ActivationFunction.sigmoidDerivative(x: weights[L][i].y.x)
                
                for j in 0..<weights[L].count {
                    if weights[L][i].x == weights[L][j].x {
                        error += weights[L][j].w * weights[L][j].y.error * g
                    }
                }
                
                weights[L][i].x.error = error
    
                let delta = weights[L][i].x.x * weights[L][i].y.error
                weights[L][i].w = weights[L][i].w + (NeuralNetwork.learningRate * delta * g)
            }
            
            L -= 1
            
            if L < 0 { break }
        }
    }

  /*  func backprop() {
     
        var l = layers.count - 2
        
        while true {
            var offset = 0
            let count = (layers[l + 1].neurons.count == 1) ? 1 : layers[l + 1].neurons.count - 1
            
            for i in 0..<layers[l].neurons.count {
                var error: Float = 0.0

                for j in 0..<layers[l + 1].neurons.count {
                    let g = ActivationFunction.sigmoidDerivative(x: layers[l + 1].neurons[j].x)
 
                    print(layers[l + 1].neurons[j].error)
                    error += weights[l][j + offset] * layers[l + 1].neurons[j].error * g
                }
                
                layers[l].neurons[i].error = error
                offset += count
            }

            l -= 1

            if l < 0 {
                break
            }
        }

        l = layers.count - 2
        
        while true {
            var offset = 0
            let count = (layers[l + 1].neurons.count == 1) ? 1 : layers[l + 1].neurons.count - 1
            let startIndex = (layers[l + 1].neurons.count == 1) ? 0 : 1
    
            for j in startIndex..<layers[l + 1].neurons.count {
                let g = ActivationFunction.sigmoidDerivative(x: layers[l + 1].neurons[j].z)
                var nextError: Float = 0
                
                for i in 0..<layers[l].neurons.count {
                    let index = (startIndex == 0) ? i : i - 1
                    
                    nextError += weights[l][index + offset] * layers[l + 1].neurons[j].error * g
                    weights[l][index + offset] = weights[l][index + offset] - NeuralNetwork.learningRate * layers[l + 1].neurons[j].error * layers[l + 1].neurons[j].x * g
                }
                
                layers[l].neurons[j].error = nextError
                
                offset += count
            }
            
            l -= 1
            
            if l < 0 {
                break
            }
        }
    }*/
    
    // MARK: - Helpers
    
    private func addAverageError() {
        var sum: Float = 0.0
        
        for error in errors {
            sum += error
        }
        
        averageErrors.append(sum / Float(errors.count))
    }
    
    // MARK: - Model
    
    func importModel() {
        
    }
    
    func exportModel() {
        
    }
    
    /*init(inputLayerSize: Int, hiddenLayerSize: Int, outputLayerSize: Int) {
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
            error = layers[i].train(error: error, alpha: learningRate, m: momentum)
        }
    }*/
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
