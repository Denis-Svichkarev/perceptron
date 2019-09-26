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
        
        let x: [Double] = [1, 0, 0]
        let theta1: [Double] = [-30, 20, 20]
        let theta2: [Double] = [10, -20, -20]
        let theta3: [Double] = [-10, 20, 20]
        let theta = [theta1, theta2, theta3]
        
        // --------------------------------------- //
        
        var layers = [NetworkLayer]()
        layers.append(NetworkLayer())
        
        let network = Network(x: x, theta: theta, layers: layers)
        
        let result = network.run()
        print("Result: \(result)")
    }
}

