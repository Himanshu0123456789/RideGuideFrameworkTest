//
//  RideGuideHelper.swift
//  RideGuideFramework
//
//  Created by orange on 10/04/24.
//

import Foundation

extension Data {
    static func dataWithValue(value: UInt8) -> Data {
        var variableValue = value
        return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
    }
}

/// This is an helper class for common reusabe functionality
final class RideGuideHelper {
    static let shared = RideGuideHelper()
    private init() {}
    
    /// This is here to split the give string from the split symbol
    /// And return the first part of the string from where it split first time
    /// - Parameters:
    ///   - mainString: String about to split
    ///   - splitSymbol: Split character,  where main string will split
    /// - Returns: This will return the first part of the splitted string
    static func extractReqDataFromString(mainString: String, splitSymbol : Character) -> Substring {
        let splitArr = mainString.split(separator: splitSymbol)
        if splitArr.count > 0 {
            return splitArr[0]
        }
        return ""
    }
}


