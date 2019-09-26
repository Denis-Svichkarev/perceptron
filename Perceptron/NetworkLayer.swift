//
//  NetworkLayer.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 26/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class NetworkLayer: NSObject {

    var neuronsCount = 2
    
    func run(x: [Double], theta: [Double]) -> Double {
        let neuron = Neuron()
        neuron.x = x
        neuron.theta = theta
        return neuron.activate()
    }
}
