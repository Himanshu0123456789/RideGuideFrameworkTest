//
//  UserDefaultData.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

import Foundation

final class UserDefaultData: NSObject {
    static let shared: UserDefaultData = { UserDefaultData() }()
    private let defaults: UserDefaults = UserDefaults.standard;
    private override init() {}
    
    //MARK: - Save data correspending the key
    private func save(object:Any, key:String) {
        defaults.setValue(object, forKeyPath: key);
        defaults.synchronize();
    }
    
    //MARK: Get data correspending the key
    private func get(key:String) -> Any? {
        return defaults.object(forKey: key)
    }
    
    //MARK: - Save Rideguide bike configuration
    func saveBikeConfiguration(bikeConfig : Data) {
        do {
            let jsonData = try JSONEncoder().encode(bikeConfig)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            save(object: bikeConfig, key: Uniquekeys.bikeConfiguration.rawValue)
        } catch {
            print("Error encoding JSON: \(error)")
            save(object: "", key: Uniquekeys.bikeConfiguration.rawValue)
        }
    }
    
    //MARK: - Get data for Rideguide bike configuration
    func getBikeConfiguration() -> BikeDto? {
        if let decryptionData = get(key: Uniquekeys.bikeConfiguration.rawValue) as? String {
            if let jsonData = decryptionData.data(using: .utf8) {
                do {
                    let configData = try JSONDecoder().decode(BikeDto.self, from: jsonData)
                    return configData
                } catch {
                    print("Error decoding JSON: \(error)")
                    return nil
                }
            }
            return nil
        }
        return nil
    }
}
