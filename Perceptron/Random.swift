//
//  Random.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 14/10/2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import Foundation

public extension ClosedRange where Bound: FloatingPoint {
    func random() -> Bound {
        let range = self.upperBound - self.lowerBound
        let randomValue = (Bound(arc4random_uniform(UINT32_MAX)) / Bound(UINT32_MAX)) * range + self.lowerBound
        return randomValue
    }
}
