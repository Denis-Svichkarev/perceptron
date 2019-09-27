//
//  ViewController.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 6/14/19.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [-30, 20, 20] - AND
        // [-10, 20, 20] - OR
        // [10, -20, -20] - NOT AND NOT
        
//        let x: [Double] = [1, 0, 0]
//        let theta1: [Double] = [-30, 20, 20]
//        let theta2: [Double] = [10, -20, -20]
//        let theta3: [Double] = [-10, 20, 20]
//        let theta = [theta1, theta2, theta3]
        
        // --------------------------------------- //
        
        //var layers = [NetworkLayer]()
        //layers.append(NetworkLayer(neuronsCount: 2))
        
        /*
            Training
         
            1. Randomly initialize weights
            2. Forward propagation to get h(x) for any x
            3. Compute cost function J(Theta)
            4. Backpropagation to compute partial derivatives d/dTheta * J(Theta) (Compute D = D + delta(a))
            5. Gradient checking
            6. Gradient descent to minimize J(Theta) and find best Theta
         
            Prediction
         
            1. y = data * Theta
         
            Theta is matrix of weights.
        */
        
        let dataX = [[3.0,  5.0],
                     [5.0,  1.0],
                     [10.0, 2.0]]
        let inputX = Matrix(unpack: dataX)
        
        let network = NeuralNetwork(inputLayerSize: 2, outputLayerSize: 1, hiddenLayerSize: 3)
        
        if let a3 = network.forward(x: inputX) {
            print("X is \(inputX)")
            print("a3 is \(a3)")
            
        } else {
            print("error")
        }
    }
}

