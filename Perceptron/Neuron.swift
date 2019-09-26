//
//  Neuron.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit
import Surge

class Neuron: NSObject {

    var x: [Double]?
    var theta: [Double]?
    
    func activate() -> Double {
        guard let x = x, let theta = theta, x.count == theta.count else {
            print("# activation error")
            return 0
        }
        
        let mul = Surge.mul(theta, y: x)
        let h = sigmoid(z: Surge.sum(mul))
        return (h * 1000).rounded(.toNearestOrEven) / 1000
    }
    
    func sigmoid(z: Double) -> Double {
        return 1.0 / (1.0 + exp(-z))
    }
}
