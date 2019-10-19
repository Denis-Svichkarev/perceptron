//
//  Double.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 19.10.2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
