//
//  BluetoothManager.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

import UIKit
import Foundation
import CoreBluetooth
//import CRNotifications



/// Bike Feature Type
public enum BikeFeatureType: Substring {
    case Commuter
    case CommonFeatures
    case Navigation
    case CommonFeatureMusic
}

/// Bike Hardware Manufacturer
public enum ServiceType: String, CodingKey {
    case telit
    case hmcl
}

/// Protocols for getting instructions form bluetooth manager
@objc public protocol BluetoothActivityDelegates {
    /// When BLE finds the available bike clusters`
    @objc optional func didFoundDevice(identifier: UUID)
    /// This is used when BLE connection  establishment with bike cluster gets failed
    @objc optional func failToConnect()
    /// When bike cluster  connected successfully
    @objc optional func successfullyConnectWithBluetooth()
    /// when bike cluster disconnected
    @objc optional func bleDisconnected(peripheralIdentifier: UUID)
    /// When bluetooth state changed from on to off
    @objc optional func bleOff(isConnected: Bool)
    /// When bluetooth state changed from off to on
    @objc optional func bleOn()
}

//MARK: - Constants/Variables
class BluetoothManager: NSObject {
    static let shared = BluetoothManager()
    private override init() {}
    
    private lazy var manager: CBCentralManager = CBCentralManager(delegate: self, queue: nil)
    private var targetService: CBService?
    private var uartTxCharacteristic: CBCharacteristic?
    private var uartTxCreditsCharacteristic: CBCharacteristic?
    private var uartRxCharacteristic: CBCharacteristic?
    private var uartRxCreditsCharacteristic: CBCharacteristic?
    private var isHadToPerformServiceDiscovery: Bool = false
    private var isDidSubscribeUARTTx: Bool = false
    private var isDidSubscribeUARTTxCredits: Bool = false
    private var isDidGrantInitialUARTRxCredits: Bool = false
    private var isWriting: Bool = false
    private var localUARTCreditsCount: Int = 0
    private var pendingLocalUARTCreditsCount: Int = 0
    private var isConnecting: Bool = false
}

extension BluetoothManager {
    // This is here to begin the bluetooth functionality
    //** scan avilable BluetoohDevice  ****//
    public func bluetoohServiceStart(controllerName: String = "") {
        //comingFromController = controllerName
        self.manager.stopScan()
        self.performStopBleScanningAfterDelay()
        //Check wether bluetooth is on or off
        if !(router.bluetoothState ?? true) {
            router.bluetoothDelegate?.bleOff?(isConnected: false)
            //TODO: - Add this condition inside  bleOff function call
//            if controllerName == "BLEVC" {
//                Common.showAlert(alertMessage: pleaseCheckBleConnection, alertButtons: [okTitle]) { _ in
//                }
//            }
        } else {
            manager.scanForPeripherals(withServices:[serviceUuid,nonTioServiceUuid].map{ CBUUID(string: $0) }, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
        }
    }
    
    //** Stop Scanning BluetoohDevice  ****//
    public func stopScanning() {
        self.manager.stopScan()
    }
    
    //***** connection to BLE Device ******//
    public func connectDevice(peripheral: CBPeripheral) {
        router.peripheral = peripheral
        isHadToPerformServiceDiscovery = false
        isDidSubscribeUARTTx = false
        isDidSubscribeUARTTxCredits = false
        isDidGrantInitialUARTRxCredits = false
        uartTxCharacteristic = nil
        uartTxCreditsCharacteristic = nil
        isWriting = false
        isConnecting = true
        self.processTIOConnection()
    }
    
    // Disconnect BLE Device
    public func disconnectDevice(peripheral: CBPeripheral) {
        manager.cancelPeripheralConnection(peripheral)
    }
    
    //*** writing UART TO BLE Device *** //
    public func writeUARTData(_ data: Data) {
        if router.isConnected {
            return
        }
        router.peripheral.writeValue(data, for: uartRxCharacteristic!, type: .withoutResponse)
    }
}

//MARK: - CBcentralManager delegate confirmance
extension BluetoothManager: CBCentralManagerDelegate {
    /// Device Bluetooth State
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //Check The bluetooth state
        switch central.state {
                //Bluetooth is on
            case .poweredOn:
                self.manager.stopScan()
                central.scanForPeripherals(withServices: [serviceUuid, nonTioServiceUuid].map{ CBUUID(string: $0) }, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
                self.performStopBleScanningAfterDelay()
                router.bluetoothState = true
                router.bluetoothDelegate?.bleOn?()
            //TODO: - Add this condition inside  bleOn function call
//            if Common.getTopViewController()?.className != "AppPermissionVc" && Common.getTopViewController()?.className != "UpdateAppVersionVC"  {
//                Common.getTopViewController()?.dismiss(animated: true)
//            }
                //Bluetooth is off
            case .poweredOff:
                BluetoothManager.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.scaningStop), object: nil)
            if router.isConnected {
                router.isConnected = false
                router.rideStart = false
                    //Common.showMessage(message: bluetoothDisconnected)
                router.bluetoothDelegate?.bleOff?(isConnected: true)
                }
                router.bluetoothState = false
                router.bluetoothDelegate?.bleOff?(isConnected: false)
            //TODO: - Add this condition inside  bleOff function call
//                if comingFromController == "BLEVC" {
//                    Common.showAlert(alertMessage: pleaseCheckBleConnection, alertButtons: [okTitle]) { _ in
//                    }
//                }
            default:
                break
        }
    }
    
    /// Available (Discovered) bluetooth devices(Bike clusters)
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if router.peripherals.first(where: { (device) -> Bool in
            return device.identifier == peripheral.identifier
        }) == nil {
            router.peripherals.append(peripheral)
        }
            router.bluetoothDelegate?.didFoundDevice!(identifier: peripheral.identifier)
    }
    
    /// Connected with bluetooth
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        router.peripheral = peripheral
        router.peripheral.delegate = self
        guard let services = peripheral.services else {
            router.peripheral.discoverServices(nil)
            return
        }
        if let service = services.first {
            targetService = service
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    /// Failed to connect with bluetooth
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        router.isConnected = false
        router.rideStart = false
    }
        
    /// This calls When user cancel to pair and when user disconnect with bluetooth
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral,error: Error?) {
        if (router.bluetoothDelegate != nil) {
            if router.bluetoothState ?? false {
                if router.isConnected {
                    //TODO: - Need to add this condition in ble disconnect function inside bleDisconnected fucntion
//                    if (delegate as AnyObject?) is HomeViewController && isVehicleChanged == false {
                    router.bluetoothDelegate?.bleDisconnected?(peripheralIdentifier: peripheral.identifier)
//                    }
                }
            }
        }
        
        if !(router.bluetoothState ?? true) {
            if router.isConnected {
                router.isConnected = false
                router.rideStart = false
//                CRNotifications.showNotification(textColor: colors.appBlackColor, backgroundColor: colors.appWhiteColor, image: UIImage(named: self.isConnected ? "lightGreenSuccessChk" : "errorCross"), title: kAppName, message: bluetoothDisconnect, dismissDelay: 4)
            }
        } else {
            router.isConnected = false
            router.rideStart = false
        }
    }
}

//MARK: - CBPeripheralDelegate delegate confirmance
extension BluetoothManager: CBPeripheralDelegate {
    /// Discover peripherl services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        targetService = nil
        for service: CBService in services {
            if service.uuid.isEqual(ClusterUuid.shared.returnServiceUuidValue()) {
                targetService = service
                break
            }
        }
        self.processTIOConnection()
    }
    /// Discover service characterstics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        for characteristic: CBCharacteristic in characteristics {
            if characteristic.uuid.isEqual(ClusterUuid.shared.returnUartTxUuidValue()) {
                uartTxCharacteristic = characteristic
            }
            else if characteristic.uuid.isEqual(ClusterUuid.shared.returnUartTxCreditsUuidValue()) {
                uartTxCreditsCharacteristic = characteristic
            }
            else if characteristic.uuid.isEqual(ClusterUuid.shared.returnUartRxUuidValue()) {
                uartRxCharacteristic = characteristic
            }
            else if characteristic.uuid.isEqual(ClusterUuid.shared.returnUartRxCreditsUuidValue()) {
                uartRxCreditsCharacteristic = characteristic
            }
        }
        self.processTIOConnection()
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid.isEqual(ClusterUuid.shared.returnUartRxCreditsUuidValue()) {
            if error == nil {
                if isConnecting {
                    isDidGrantInitialUARTRxCredits = true
                    processTIOConnection()
                }
                localUARTCreditsCount += pendingLocalUARTCreditsCount
                pendingLocalUARTCreditsCount = 0
            } else {
                return
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
       if error != nil {
           manager.cancelPeripheralConnection(peripheral)
           if router.bluetoothDelegate != nil {
               router.bluetoothDelegate?.failToConnect!()
           }
           return
       }
       if characteristic.uuid.isEqual(ClusterUuid.shared.returnUartTxUuidValue()) {
           isDidSubscribeUARTTx = true
       } else if characteristic.uuid.isEqual(ClusterUuid.shared.returnUartTxCreditsUuidValue()) {
           isDidSubscribeUARTTxCredits = true
       }
       processTIOConnection()
   }
}
 

//MARK: - BluetoothManager internal functionality
extension BluetoothManager {
    
    /// This is here to stop bluetooth scanning after a certain time
    ///
    /// This also cancels perviously called perform function request
    /// This perform an action to stop bluetooth scanning after 300 seconds
    private func performStopBleScanningAfterDelay() {
        BluetoothManager.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.scaningStop), object: nil)
        BluetoothManager.perform(#selector(self.scaningStop), with: nil, afterDelay: 300)
    }
    
    /// This stops the bluetooth scanning
    @objc private func scaningStop() {
        self.manager.stopScan()
        //As perfomed function has been called so cancel previously perfomed request(if pending)
        BluetoothManager.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.scaningStop), object: nil)
    }
    
    //**** establish Connection and discover services and charecteristic of selected peripheral *******//
     private func processTIOConnection() {
        if router.peripheral.state != .connected {
            // first we need to establish a BLE connection
            manager.connect(router.peripheral, options: nil)
        } else if router.peripheral.services == nil || targetService == nil {
            // BLE connection has been established but the iOS service instance is not known, so a service discovery is required.
            if ((router.bikeServiceType ?? "").contains("+"))  {
                if let services = router.peripheral.services {
                    for service in services {
                        if "\(service.uuid)" == nonTioServiceUuid {
                            router.bikeServiceType = ServiceType.hmcl.rawValue
                        } else if "\(service.uuid)" == serviceUuid {
                            router.bikeServiceType = ServiceType.telit.rawValue
                        }
                    }
                }
            }
            //In other conditions direct match with service Type === with below function
            discoverServices()
            isHadToPerformServiceDiscovery = true
        } else if isHadToPerformServiceDiscovery || uartTxCharacteristic == nil || uartTxCreditsCharacteristic == nil {
            isHadToPerformServiceDiscovery = false
            // TIO service instance is known but not all characteristics instances are known, so a characteristics discovery is required.
            discoverCharacteristics()
        } else if !isDidSubscribeUARTTxCredits {
            // UART TX credits notification subscription is required.
            subscribe(to: uartTxCreditsCharacteristic!)
        } else if !isDidSubscribeUARTTx {
            // UART TX data notification subscription is required.
            subscribe(to: uartTxCharacteristic!)
        } else if !isDidGrantInitialUARTRxCredits {
            // UART RX credits have to be granted to the peripheral in order to establish the TerminalIO connection
            grantLocalUARTCredits()
        } else {
            router.isConnected = true
            isConnecting = false
            router.bluetoothDelegate?.successfullyConnectWithBluetooth?()
            BluetoothManager.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.scaningStop), object: nil)
        }
    }
    
    /// Get services and charecteristic
    private func discoverServices() {
        uartTxCharacteristic = nil
        uartTxCreditsCharacteristic = nil
        router.peripheral.discoverServices([ClusterUuid.shared.returnServiceUuidValue()])
    }
    
    /// Discover Characteristics
    private func discoverCharacteristics() {
        router.peripheral.discoverCharacteristics([ClusterUuid.shared.returnUartTxUuidValue(), ClusterUuid.shared.returnUartTxCreditsUuidValue(), ClusterUuid.shared.returnUartRxUuidValue(), ClusterUuid.shared.returnUartRxCreditsUuidValue()], for: targetService!)
    }
    
    private func subscribe(to characteristic: CBCharacteristic) {
        router.peripheral.setNotifyValue(true, for: characteristic)
    }
    
    private func grantLocalUARTCredits() {
        if pendingLocalUARTCreditsCount != 0 {
            return
        }
        pendingLocalUARTCreditsCount = maxUartCreditsCount - localUARTCreditsCount
        let value: UInt8 = (UInt8)(pendingLocalUARTCreditsCount)
        let valueData = Data.dataWithValue(value: value)
        router.peripheral.writeValue(valueData, for: uartRxCreditsCharacteristic!, type: .withResponse)
    }
}
