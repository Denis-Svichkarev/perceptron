//
//  Network.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class Network: NSObject {

    var x: [Double]?
    var theta: [[Double]]?
    var layers: [NetworkLayer]?
    
    init(x: [Double], theta: [[Double]], layers: [NetworkLayer]) {
        self.x = x
        self.theta = theta
        self.layers = layers
    }
    
    func run() -> Double {
        guard let x = x, let theta = theta, let layers = layers else {
            print("# network error")
            return 0
        }
        
        var result: Double = 0
        
        for layer in layers {
         
            let a1 = layer.run(x: x, theta: theta[0])
            let a2 = layer.run(x: x, theta: theta[1])
            let a3 = layer.run(x: [1, a1, a2], theta: theta[2])
            
            result = a3
        }
        
        return result
    }
}
