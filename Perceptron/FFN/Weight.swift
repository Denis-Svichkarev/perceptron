//
//  Weight.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 12/10/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class Weight: NSObject {

    var prev: Neuron!
    var next: Neuron!
    
    var w: Float = 0
    
    override init() {}
    
    init(w: Float) {
        self.w = w
    }
    
    func log() {
        print(prev.name + "-" + next.name)
    }
}
