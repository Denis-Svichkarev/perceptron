//
//  Log.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 19.10.2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class Log: NSObject {
    
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
                    stringX += "] : "
                }
            }
            
            let prediction = Double(network.forward(input: x, targetOutput: nil))
            
            stringX += "\((prediction * 100).rounded(toPlaces: 2))%\n"
        }
        
        return stringX
    }
}
