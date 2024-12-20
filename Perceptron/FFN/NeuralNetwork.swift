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
    
    var errors: [[Float]] = []            // array of errors of the neurons output per an iteration
    var averageErrors: [[Float]] = []     // array of average errors per N iterations
    
    static var iterations: Int = 10
    static var learningRate: Float = 0.3
    static var momentum: Float = 1
    
    // MARK: - Algorithm
    
    init(inputLayerSize: Int, hiddenLayerSize: Int, outputLayerSize: Int) {
        
        let initLog = "NN init: \(inputLayerSize)x\(hiddenLayerSize)x\(outputLayerSize), iterations: \(NeuralNetwork.iterations), rate: \(NeuralNetwork.learningRate), momentum: \(NeuralNetwork.momentum)"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeuralNetworkNotification"), object: initLog)
        
        layers.append(Layer(layerType: .input, index: 1, count: inputLayerSize, bias: true))
        layers.append(Layer(layerType: .hidden, index: 2, count: hiddenLayerSize, bias: true))
      //  layers.append(Layer(layerType: .hidden, index: 3, count: hiddenLayerSize, bias: true))
        layers.append(Layer(layerType: .output, index: 3, count: outputLayerSize, bias: false))
        
//        let w1: [Float] = (0..<(inputLayerSize + 1) * hiddenLayerSize).map { _ in
//            return (-2.0...2.0).random()
//        }
//
//        let w2: [Float] = (0..<(hiddenLayerSize + 1) * outputLayerSize).map { _ in
//            return (-2.0...2.0).random()
//        }

        var w1 = [Weight]()
        var w2 = [Weight]()
       //var w3 = [Weight]()
        
        for _ in 0..<(inputLayerSize + 1) * hiddenLayerSize {
            //w1.append(Weight(w: weights1[i]))
            w1.append(Weight(w: (-2.0...2.0).random()))
        }
        
//        for _ in 0..<(hiddenLayerSize + 1) * hiddenLayerSize {
//            w2.append(Weight(w: (-2.0...2.0).random()))
//        }
        
        for _ in 0..<(hiddenLayerSize + 1) * outputLayerSize {
            //w2.append(Weight(w: weights2[i]))
            w2.append(Weight(w: (-2.0...2.0).random()))
        }
        
        weights.append(w1)
        weights.append(w2)
//        weights.append(w3)
        
        for i in 0..<layers.count - 1 {
            let count = (layers[i + 1].layerType == .output) ? layers[i + 1].neurons.count : layers[i + 1].neurons.count - 1
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
        let start = DispatchTime.now()
        
        for i in 0..<NeuralNetwork.iterations {
            let divider = NeuralNetwork.iterations / 10
            
            if divider >= 500 && i % divider == 0 {
                let progress = Int(Double(i) * (1.0 / Double(NeuralNetwork.iterations)) * 100)
                let timeLog = "[progress: \(progress)%]"
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeuralNetworkNotification"), object: timeLog)
                }
            }
            
            for i in 0..<targetOutput.count {
                let error = forward(input: input[i], targetOutput: targetOutput[i])
                
                if targetOutput[i].count > 1 {
                    errors.append(error.error!)
                    
                } else {
                    errors.append(error.error!)
                }
                
                backprop()
            }
            
            //print("\(weights.last![0].w) : \(weights.last![1].w) : \(weights.last![2].w) : \(weights.last![3].w)")
            addAverageError()
            errors.removeAll()
        }
        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        let timeLog = "Neural network training time \(timeInterval.rounded(toPlaces: 3)) seconds"
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NeuralNetworkNotification"), object: timeLog)
        }
    }
    
    func forward(input: [Float], targetOutput: [Float]?) -> (error: [Float]?, result: [Float]) {
        
        for i in 0..<input.count {
            weights[0][i].prev.x = input[i]
        }
        
        weights.last!.last!.prev.x = 1
        
        for L in 0..<layers.count - 1 {
            layers[L].neurons.last!.x = 1
            let count = (layers[L + 1].layerType == .output) ? layers[L + 1].neurons.count : layers[L + 1].neurons.count - 1
            
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
        
        var outputs = [Neuron]()
        
        for i in 0..<weights.last!.count {
            if !outputs.contains(weights.last![i].next) {
                outputs.append(weights.last![i].next)
            }
        }
        
        var result = [Float](repeating: 0, count: layers.last!.neurons.count)
        
        for i in 0..<layers.last!.neurons.count {
            result[i] = outputs[i].x
        }
        
        if let targetOutput = targetOutput {
            var error = [Float](repeating: 0, count: targetOutput.count)
            
            for i in 0..<targetOutput.count {
                error[i] = targetOutput[i] - outputs[i].x
                outputs[i].error = error[i]
            }
            
            return (error, result)
            
        } else {
            
            return (nil, result)
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

    // MARK: - Data
    
    func importTrainingData(name: String) -> (data: [[Float]], results: [[Float]])? {
        
        if let text = getStringFromFilePath(name) {
            var data = [[Float]]()
            var results = [[Float]]()
            
            let lines = text.lines
            
            for i in 0..<lines.count {
                let resultDelimiter = ":"
                let token1 = lines[i].components(separatedBy: resultDelimiter)
                
                let exampleDelimiter = ";"
                
                let targets = token1[0].components(separatedBy: exampleDelimiter)
                let features = token1[1].components(separatedBy: exampleDelimiter)
                
                results.append([])
                
                for j in 0..<targets.count {
                    if let label = Float(targets[j]) {
                        results[i].append(label)
                    }
                }
                
                data.append([])
                
                for j in 0..<features.count {
                    if let example = Float(features[j]) {
                        data[i].append(example)
                    }
                }
            }
            
            return (data, results)
        }
        
        return nil
    }
    
    func importTestData(name: String) -> [[Float]]? {
        
        if let text = getStringFromFilePath(name) {
            var data = [[Float]]()
            
            let lines = text.lines
            
            for i in 0..<lines.count {
                let exampleDelimiter = ";"
                let token1 = lines[i].components(separatedBy: exampleDelimiter)
                
                data.append([])
                
                for j in 0..<token1.count {
                    if let example = Float(token1[j]) {
                        data[i].append(example)
                    }
                }
            }
            
            return data
        }
        
        return nil
    }
    
    func importModel(name: String) {

        if let text = getStringFromFilePath(name) {
            weights.removeAll()
            
            let lines = text.lines
            
            for line in lines {
                let numberDelimiter = ":"
                let token1 = line.components(separatedBy: numberDelimiter)
                
                let weightDelimiter = ";"
                let token2 = token1[1].components(separatedBy: weightDelimiter)
                
                var weights = [Weight]()
                
                for i in 0..<token2.count {
                    if let w = Float(token2[i]) {
                        weights.append(Weight(w: w))
                    }
                }
                
                self.weights.append(weights)
            }
            
            for i in 0..<layers.count - 1 {
                let count = (layers[i + 1].layerType == .output) ? layers[i + 1].neurons.count : layers[i + 1].neurons.count - 1
                for i2 in 0..<count {
                    for i3 in 0..<layers[i].neurons.count {
                        weights[i][i3 + i2 * layers[i].neurons.count].prev = layers[i].neurons[i3]
                        weights[i][i3 + i2 * layers[i].neurons.count].next = layers[i + 1].neurons[i2]
                    }
                }
            }
        }
    }
    
    func exportModel() {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy HH-mm-ss"
        let dateString = formatter.string(from: date)
        
        var text = ""
        
        for i in 0..<weights.count {
            text.append("\(i):")
            
            for j in 0..<weights[i].count {
                text.append("\(weights[i][j].w);")
            }
            
            if i != weights.count - 1 {
                text.append("\n")
            }
        }
        
        writeToFileString("weights " + dateString, text: text)
    }
    
    // MARK: - Helpers
    
    private func addAverageError() {
        let targetSize = layers.last!.neurons.count
        
        var averageError = [Float]()
        var sum: [Float] = [Float](repeating: 0, count: targetSize)
        
        for i in 0..<targetSize {
            for j in 0..<errors.count {
                sum[i] += errors[j][i]
            }
            
            averageError.append(sum[i] / Float(errors.count))
        }
        
        averageErrors.append(averageError)
    }
}
