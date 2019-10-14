//
//  NetworkLayer.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

enum LayerType {
    case input, hidden, output
}

class Layer: NSObject {
    
    var layerType: LayerType?
    var index: Int = 0
    var neurons: [Neuron] = []
    
//    var input: [Neuron] = []
//    var output: [Neuron] = []
    
    init(layerType: LayerType, index: Int, count: Int, bias: Bool) {
        self.layerType = layerType
        self.index = index
        
        for i in 0..<count {
            neurons.append(Neuron(name: "x\(i)(\(index))"))
        }
        
        if bias {
            neurons.append(Neuron(name: "x\(count)(\(index))"))
        }
    }
    
//    private var output: [Float]
//    private var input: [Float]
//    private var weights: [Float]
    
    /*init(inputSize: Int, outputSize: Int) {
        self.output = [Float](repeating: 0, count: outputSize)
        self.input = [Float](repeating: 0, count: inputSize + 1)
        self.weights = (0..<(1 + inputSize) * outputSize).map { _ in
            return (-2.0...2.0).random()
        }
    }
    
    public func run(inputArray: [Float]) -> [Float] {
        
        for i in 0..<inputArray.count {
            input[i] = inputArray[i]
        }
        
        input[input.count - 1] = 1
        var offSet = 0
        
        for i in 0..<output.count {
            for j in 0..<input.count {
                output[i] += weights[offSet+j] * input[j]
            }
            
            output[i] = ActivationFunction.sigmoid(x: output[i])
            offSet += input.count
        }
        
        return output
    }
    
    public func train(error: [Float], alpha: Float, m: Float) -> [Float] {
        
        var offset = 0
        var nextError = [Float](repeating: 0, count: input.count) // берем все инпуты с предыдущего слоя и именно столько новых ошибок передадим им
        
        for i in 0..<output.count {
            let g = ActivationFunction.sigmoidDerivative(x: output[i]) // производная ФА с аргументом, полученным при forward prop
            
            for j in 0..<input.count {
                let weightIndex = offset + j
                nextError[j] += weights[weightIndex] * error[i] * g // посчитали новую ошибку
                weights[weightIndex] = weights[weightIndex] * m + (alpha * input[j] * error[i] * g) // пересчитали все веса на этом слое
            }
            
            offset += input.count // дурацкий сдвиг по весам, надо бы избавиться от такой структуры циклов
        }
        
        return nextError
    }*/
}
