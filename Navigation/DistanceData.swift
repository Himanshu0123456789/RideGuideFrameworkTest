//
//  DistanceData.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

import Foundation
/// This is here for dstance unit symbol
struct distanceSymbole {
    let distanceUnit: String
}

extension distanceSymbole {
    init(directions: Double, unit: String) throws {
        var direction = String()
        direction = unit == "m" ? "1" : "k"
        self.distanceUnit = direction
    }
}
