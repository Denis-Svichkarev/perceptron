//
//  Neuron.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class Neuron: NSObject {

    var name: String = ""
    
    var x: Float = 0
    var z: Float = 0
    var error: Float = 0
    
    override init() {}
    
    init(x: Float) {
        self.x = x
    }
    
    init(name: String) {
        self.name = name
    }
    
    /*var x: [Double]?
    var theta: [Double]?
    
    init(x: [Double], theta: [Double]) {
        self.x = x
        self.theta = theta
    }
    
    func activate() -> Double {
        guard let x = x, let theta = theta, x.count == theta.count else {
            print("# activation error")
            return 0
        }
        
        let mul = theta * x
        let h = sigmoid(z: mul)
        return (h * 1000).rounded(.toNearestOrEven) / 1000
    }
    
    func sigmoid(z: Double) -> Double {
        return 1.0 / (1.0 + exp(-z))
    }*/
}
