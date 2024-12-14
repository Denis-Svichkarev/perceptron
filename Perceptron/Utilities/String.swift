//
//  String.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 18.10.2019.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import Foundation

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}
