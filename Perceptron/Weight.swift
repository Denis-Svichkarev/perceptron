//
//  Weight.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 12/10/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class Weight: NSObject {

    var x: Neuron!
    var y: Neuron!
    
    var w: Float = 0
    
    override init() {}
    
    init(w: Float) {
        self.w = w
    }
    
    func log() {
        print(x.name + "-" + y.name)
    }
}
