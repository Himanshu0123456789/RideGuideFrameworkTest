//
//  ClusterUuid.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

import CoreBluetooth

/// Find bike hardware uuid's according to hardware manufacturer
final class ClusterUuid: NSObject {
  static let shared = ClusterUuid()
  private override init() {}
    
  func returnServiceUuidValue() -> CBUUID {
        var _serviceUUID: CBUUID? = nil
        if _serviceUUID == nil {
            if router.bikeServiceType == ServiceType.hmcl.rawValue {
                _serviceUUID = CBUUID(string: nonTioServiceUuid)
            } else {
                _serviceUUID = CBUUID(string:serviceUuid)
            }
        }
        return _serviceUUID!
    }
    
   func returnUartRxUuidValue() -> CBUUID {
        var _uartRxUUID: CBUUID? = nil
        if _uartRxUUID == nil {
            if router.bikeServiceType == ServiceType.hmcl.rawValue {
                _uartRxUUID = CBUUID(string:nonTioUartRxUuid )
            } else {
                _uartRxUUID = CBUUID(string: uartRxUuid)
            }
        }
        return _uartRxUUID!
    }
    
   func returnUartTxUuidValue() -> CBUUID {
        var _uartTxUUID: CBUUID? = nil
        if _uartTxUUID == nil {
            if router.bikeServiceType == ServiceType.hmcl.rawValue {
                _uartTxUUID = CBUUID(string:nonTioUartTxUuid)
            } else {
                _uartTxUUID = CBUUID(string: uartTxUuid)
            }
        }
        return _uartTxUUID!
    }
    
   func returnUartRxCreditsUuidValue() -> CBUUID {
        var _uartRxCreditsUUID: CBUUID? = nil
        if _uartRxCreditsUUID == nil {
            if router.bikeServiceType == ServiceType.hmcl.rawValue {
                _uartRxCreditsUUID = CBUUID(string: nonTioUartRxCreditsUuid)
            } else {
                _uartRxCreditsUUID = CBUUID(string: uartRxCreditsUuid)
            }
        }
        return _uartRxCreditsUUID!
    }
    
    func returnUartTxCreditsUuidValue() -> CBUUID {
        var _uartTxCreditsUUID: CBUUID? = nil
        if _uartTxCreditsUUID == nil {
            if router.bikeServiceType == ServiceType.hmcl.rawValue {
                _uartTxCreditsUUID = CBUUID(string:nonTioUartTxCreditsUuid)
            } else {
                _uartTxCreditsUUID = CBUUID(string: uartTxCreditsUuid)
            }
        }
        return _uartTxCreditsUUID!
    }
}

