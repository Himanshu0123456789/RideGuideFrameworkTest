//
//  BikeDto.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

import Foundation

public struct BikeDto: Codable {
    public var modelName: String?
    public var modelCode: String?
    public var bleName: String?
    public var vdsCode: String?
    public var serviceType: String?
    public var featureType: String?
    
    enum CodingKeys: String, CodingKey {
        case modelName = "model_name"
        case modelCode = "model_code"
        case bleName = "ble_name"
        case vdsCode = "vds_code"
        case serviceType = "service_type"
        case featureType = "feature_type"
    }
}

/// Fetch bike/bikes data from json file
/// - Returns: Array of bikes
func GetBikeConfigFromJson() -> [BikeDto] {
    var bikes = [BikeDto]()
    let bundle = Bundle(identifier: "Ah.RideGuideFramework")
    guard let jsonPath = bundle?.path(forResource: "BikeList1", ofType: "json"),
          let bikeJson = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
        return bikes
    }
    
    if let bikeJsonObjects = (try? JSONSerialization.jsonObject(with: bikeJson, options: .allowFragments)) as? Array<Any> {
        for jsonObject in bikeJsonObjects {
            guard let bikeObj = jsonObject as? Dictionary<String, Any> else {
                continue
            }
            guard let modelName = bikeObj["model_name"] as? String,
                  let modelCode = bikeObj["model_code"] as? String,
                  let vdsCode = bikeObj["vds_code"] as? String,
                  let serviceType = bikeObj["service_type"] as? String,
                  let feature = bikeObj["feature_type"] as? String,
                  let blename = bikeObj["ble_name"] as? String else {
                continue
            }
            let bikeDetails = BikeDto(modelName: modelName, modelCode: modelCode, bleName: blename, vdsCode: vdsCode, serviceType: serviceType, featureType: feature)
            bikes.append(bikeDetails)
        }
    }
    return bikes
}
