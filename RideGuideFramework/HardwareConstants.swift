//
//  HardwareConstants.swift
//  RideGuideFramework
//
//  Created by orange on 11/04/24.
//

import Foundation

//Cluster Uuids
let serviceUuid: String = "FEFB"; // Used for hardware scanning
let uartRxUuid: String = "00000001-0000-1000-8000-008025000000";
let uartTxUuid: String = "00000002-0000-1000-8000-008025000000";
let uartRxCreditsUuid: String = "00000003-0000-1000-8000-008025000000";
let uartTxCreditsUuid: String = "00000004-0000-1000-8000-008025000000";

let nonTioServiceUuid = "E837D9A2-9C49-4493-9547-8E6918A59CA8"; // Used for hardware scanning
let nonTioUartRxUuid = "64AECB40-849A-44F1-934F-ADDC4B316423";
let nonTioUartTxUuid = "B792A4BB-DB87-436A-9066-DB63C5FB3F00"; // Used for HMCL & Telit
let nonTioUartRxCreditsUuid = "F535DD6E-7975-4ABD-9719-491E38A81179";
let nonTioUartTxCreditsUuid = "36E8614B-2DED-45C1-9AD3-C9F59A01F21E";

let maxUartDataSize: NSInteger = 20;
let maxUartCreditsCount: NSInteger = 255;
let errorDomain: String = "TIOErrorDomain";
