//
//  BatteryLevel.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

struct batteryLevelInHex {
   let battery: String
}
/********* show the batteryLevel to BLE Decive all the level has the some unique code to display  *********/
extension batteryLevelInHex {
    
    init(battery: Int) throws {
        let featureType: BikeFeatureType.RawValue = router.getBikeFeature()//BluetoothManager.shared.getBikeFeature()
        var batteryTower = String()
        // Battery cases modifies as per Explained in cluster for version 2, Version 1 will remain same in other condition
        if featureType == BikeFeatureType.Commuter.rawValue || featureType == BikeFeatureType.Navigation.rawValue {
            switch (battery) {
            case 0...19:
                batteryTower = "0"
            case 20...39:
                batteryTower = "1"
            case 40...59:
                batteryTower = "2"
            case 60...70:
                batteryTower = "3"
            case 80...100:
                batteryTower = "4"
            default:
                batteryTower = "default"
            }
        } else {
            if #available(iOS 17, *) {
                switch (battery) {
                case 0, 5:
                    batteryTower = "0"
                case 10, 15:
                    batteryTower = "1"
                case 20:
                    batteryTower = "2"
                case 30:
                    batteryTower = "3"
                case 40:
                    batteryTower = "4"
                case 50:
                    batteryTower = "5"
                case 60:
                    batteryTower = "6"
                case 70:
                    batteryTower = "7"
                case 80:
                    batteryTower = "8"
                case 90:
                    batteryTower = "9"
                case 100:
                    batteryTower = "A"
                default:
                    batteryTower = "default"
                }
            } else {
                switch (battery) {
                case 0...9:
                    batteryTower = "0"
                case 10:
                    batteryTower = "1"
                case 20:
                    batteryTower = "2"
                case 30:
                    batteryTower = "3"
                case 40:
                    batteryTower = "4"
                case 50:
                    batteryTower = "5"
                case 60:
                    batteryTower = "6"
                case 70:
                    batteryTower = "7"
                case 80:
                    batteryTower = "8"
                case 90:
                    batteryTower = "9"
                case 100:
                    batteryTower = "A"
                default:
                    batteryTower = "default"
                }
            }
        }
        self.battery = batteryTower
    }
}
