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
    var error: Float = 0
    
    override init() {}
    
    init(x: Float) {
        self.x = x
    }
    
    init(name: String) {
        self.name = name
    }
}
