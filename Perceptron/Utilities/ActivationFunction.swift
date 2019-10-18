//
//  ActivationFunction.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 27/09/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import Foundation

public class ActivationFunction {

    static func sigmoid(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    
    static func sigmoidDerivative(x: Float) -> Float {
        return x * (1 - x)
    }
}
