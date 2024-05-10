//
//  RideGuideFramework.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

import CoreBluetooth
let router = RideGuideFramework().entryPoint
public protocol RideGuideRouteProtocol {
    /// Bike data from json list
    var bikeList: [BikeDto] {get}
    /// Selected  bike peripheral
    var peripheral: CBPeripheral! {get set}
    /// Bluetooth activity delegate
    var bluetoothDelegate: BluetoothActivityDelegates? {get set}
    /// Connected Cluster peripheral identifier
    var bluetoothDeviceUUID: UUID? {get set}
    /// Bluetooth Sate of iphone Wether on or off
    var bluetoothState: Bool? {get set}
    /// Wethere Ride start  (for navigation type cluster)
    var rideStart: Bool {get set}  //false
    /// Wether vehicle has been changed
    var isVehicleChanged : Bool {get set} //false
    /// Wethere connected to cluster bluetooth
    var isConnected: Bool {get set}// false
    /// Array of available clusters
    var peripherals: [CBPeripheral] {get set} //[]
    /// Wether connected to internet
    var isConnectedToNetwork: Bool {get set}//= false
    /// Feature of the currently connected bike, i.e Commute, Navigator....etc
    var connectedBikeFeature: BikeFeatureType? {get set}
    var bikeServiceType: String? {get set}
    /// SDK entry
    var entryPoint: RideGuideFramework {get}
    /// This is here for saving the selected bike data
    /// - Parameter bikeData: BikeData
    func saveBike (bikeData: Data)
    /// This is here for getting the saved bike data
    /// - Returns: Bike Data in form of BikeDto
    func getBike() -> BikeDto?
//    /// This is here for saving the bike manufacturer type like HMECL, TELIT
//    /// - Parameter serviceType: ServiceType
//    func saveServiceType(serviceType: ServiceType.RawValue)
    /// This is here for knowing the bike type i.e Commuter, Navigation...etc.
    /// - Returns: BikeFeatureType
    func getBikeFeature() -> BikeFeatureType.RawValue
    
    /// This is here for geting the first part of given string by spliting it at given charactor
    /// - Parameters:
    ///   - givenString: The string which is required to split
    ///   - splitCharactor: Character at which string will split
    /// - Returns: First part of string after split
    func getReqDataFromString(givenString: String, splitCharactor: Character )-> Substring
    /// This is here to check authorization status of bluetooth
    /// - Returns: Boolean value
    func checkBLEAccess() -> Bool
    /// This is here for searching available clusters
    func searchAvailableDevices()
    /// This is here to stop Ble search operations
    func stopSearching()
    /// This is here for making BLE connection with selected device
    /// - Parameter selectedPeripheral: Selected cluster peripheral
    func establishConnectionWithSeletcedDevice(selectedPeripheral: CBPeripheral)
    /// This is here for sending data over devcie(cluster)
    /// - Parameter dataToSend: Data to be send over device(cluster)
    func sendDataToConnectedDevice(dataToSend: Data)
    /// This is here for terminating the
    /// - Parameter deviceIPeripheral: device peripheral from which connection will terminate
    func terminateConnection(deviceIPeripheral: CBPeripheral)
}

public class RideGuideFramework: RideGuideRouteProtocol {
   
    
    public var entryPoint: RideGuideFramework {
        return RideGuideFramework()
    }
    public var peripheral: CBPeripheral!
    public var bikeList: [BikeDto] = GetBikeConfigFromJson()
    public var bluetoothDeviceUUID: UUID? = nil
    public var bluetoothState: Bool? = false
    public var bluetoothDelegate: BluetoothActivityDelegates? = nil
    public var rideStart: Bool = false
    public var isVehicleChanged: Bool = false
    public var isConnected: Bool = false
    public var peripherals: [CBPeripheral] = []
    public var isConnectedToNetwork: Bool = false
    public var connectedBikeFeature: BikeFeatureType? = nil
    public var bikeServiceType: String? = nil
    public init() {}
}

extension RideGuideFramework {
    /// This is here for saving the selected bike data
    /// - Parameter bikeData: BikeData
    public func saveBike (bikeData: Data) {
        UserDefaultData.shared.saveBikeConfiguration(bikeConfig: bikeData)
    }
    
    /// This is here for getting the saved bike data
    /// - Returns: Bike Data in form of BikeDto
    public func getBike() -> BikeDto? {
        return UserDefaultData.shared.getBikeConfiguration()
    }
        
    /// This is here for knowing the bike type i.e Commuter, Navigation...etc.
    /// - Returns: BikeFeatureType
    public func getBikeFeature() -> BikeFeatureType.RawValue {
        return RideGuideHelper.extractReqDataFromString(mainString: UserDefaultData.shared.getBikeConfiguration()?.featureType ?? "", splitSymbol: " ")
    }
    
    /// This is here for geting the first part of given string by spliting it at given charactor
    /// - Parameters:
    ///   - givenString: The string which is required to split
    ///   - splitCharactor: Character at which string will split
    /// - Returns: First part of string after split
    public func getReqDataFromString(givenString: String, splitCharactor: Character )-> Substring {
        return RideGuideHelper.extractReqDataFromString(mainString: givenString, splitSymbol: splitCharactor)
    }
    
    /// This is here to check authorization status of bluetooth
    /// - Returns: Boolean value
    public func checkBLEAccess() -> Bool {
        if #available(iOS 13.1, *) {
            switch CBCentralManager.authorization {
            case .notDetermined, .allowedAlways:
                return true
            case .denied:
                return false
            default:
                print("Nothing")
            }
        }
       return true
    }
    /// This is here for searching available clusters
    public func searchAvailableDevices() {
        BluetoothManager.shared.bluetoohServiceStart()
    }
    /// This is here to stop Ble search operations
    public func stopSearching() {
        BluetoothManager.shared.stopScanning()
    }
    /// This is here for making BLE connection with selected device
    /// - Parameter selectedPeripheral: Selected cluster peripheral
    public func establishConnectionWithSeletcedDevice(selectedPeripheral: CBPeripheral) {
        BluetoothManager.shared.connectDevice(peripheral: selectedPeripheral)
    }
    
    // This is here for terminating the
    /// - Parameter deviceIPeripheral: device peripheral from which connection will terminate
    public func terminateConnection(deviceIPeripheral: CBPeripheral) {
        BluetoothManager.shared.disconnectDevice(peripheral: deviceIPeripheral)
    }
    /// This is here for sending data over devcie(cluster)
    /// - Parameter dataToSend: Data to be send over device(cluster)
    public func sendDataToConnectedDevice(dataToSend: Data) {
        BluetoothManager.shared.writeUARTData(dataToSend)
    }
}
