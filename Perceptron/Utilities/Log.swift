//
//  Log.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 19.10.2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class Log: NSObject {
    
    static let labels = ["A", "B", "C"]
    
    static func getPredictionsString(network: NeuralNetwork, data: [[Float]]) -> String {
        
        var stringX = ""
        
        for i in 0..<data.count {
            stringX += "["
            
            let x = data[i]
            
            for j in 0..<x.count {
                stringX += "\(x[j])"
                
                if j != x.count - 1 {
                    stringX += ", "
                } else {
                    stringX += "] -> "
                }
            }
            
            let predictions = network.forward(input: x, targetOutput: nil)
            
            for j in 0..<predictions.count {
                let value = Double(predictions[j] * 100).rounded(toPlaces: 2)
                
                if j != predictions.count - 1 {
                    stringX += labels[j] + ": \(value)%, "
                } else {
                    stringX += labels[j] + ": \(value)%\n"
                }
            }
        }
        
        return stringX
    }
}
