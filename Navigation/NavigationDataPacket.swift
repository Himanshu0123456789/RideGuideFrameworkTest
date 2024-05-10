//
//  NavigationData.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

import Foundation
//*** creating symbole packect**//
//*** this packt is use to write BLE DEVICE ***//
struct GattHeroNav {
    let symbol: String
}

// *** converting GATT_HERO_NAV 19 byte symbole ********//
extension GattHeroNav {
    init(directionSymbole: String, distance: String,  distanceUnit: String, timeAndUnit: String, roundaboutExit: String) throws {
        let InterNet = router.isConnectedToNetwork ? "0" : "1"
        let string = "\n1" + directionSymbole + distance + distanceUnit + timeAndUnit + "M"  + roundaboutExit + InterNet + "\n"
        self.symbol = string
    }
}
