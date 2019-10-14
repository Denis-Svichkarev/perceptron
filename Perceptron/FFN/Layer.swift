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
}
