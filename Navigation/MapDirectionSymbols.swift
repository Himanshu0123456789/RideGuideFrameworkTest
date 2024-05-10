//
//  MapDirectionSymbols.swift
//  SingleApp
//
//  Created by orange on 09/04/24.
//

//****** Mapple Map Direction Symbole ****//
let turnLeft: String = "0" //"Turn left";
let turnSharpLeft: String = "1" //"Sharp turn left";
let forkLeft: String = "2" //"Bear left"
let turnRight: String = "3" //"Turn right";
let turnSharpRight: String = "4" //"Sharp turn right";
let keepRight: String = "5" //Keep right"
let straight: String = "7" //"Stay same rd"
let destinationReached: String = "8" //"Destination"
let turnLeftIntersection: String = "11"
let turnRightIntersection: String = "12"
let turnLeftEnd: String = "13"
let turnRightEnd: String = "14"
let turnSlightLeft: String = "15" //"Slight left";
let turnSlightRight: String = "16" //"Slight right";
let sharpLeft: String = "17" //"Sharp left";
let sharpRight: String = "18" //"Sharp right";
let keepLeft: String = "19" //"Keep left"
let forkRight: String = "20" //"Keep right"
let staySameRd: String = "21" //"Stay same Rd"
let takeLeft: String = "22" //"Take left";
let takeLeftCurve: String = "23" //"Take left";
let takeRight: String = "24" //"Take right";
let takeRightCurve: String = "25" //"Take left";
let ferry: String = "36" //"Take ferry"
let uturnRight: String = "41" //"Make U-turn" //"Turnaround"
let headNorth: String = "50" //"Head north"
let rampLeft: String = "73" //"Take the ramp"
let takeRampLeft: String = "74" //"Take the ramp on the left"
let rampRight: String = "75" //"Take the ramp on the right"
//public  let merge: String =  "Merge" //-- Missing Here
let ferryTrain: String = "Ferry Train" //-- Missing Here

// Reroute Manuever
let wrongWayNE: String = "51" //"Head northeast"
let wrongWayE: String = "52" //"Head east"
let wrongWaySE: String = "53" //"Head southeast"
let wrongWayS: String = "54" //"Head south"
let wrongWaySW: String = "55" //"Head southwest"
let wrongWayW: String = "56" //"Head west"
let wrongWayNW: String = "57" //"Head northwest"
let wrongWayRotary: String = "72" //"Enter the rotary"

//Roundabout Exits
let roundaboutLeft45: String = "65" //"Roundabout exit at 45°"
let roundaboutLeft90: String = "66" //"Roundabout exit at 90°"
let roundaboutLeft135: String = "67" //"Roundabout exit at 135°"
let roundaboutLeft180: String = "68" //"Roundabout exit at 180°"
let roundaboutLeft225: String = "69" //"Roundabout exit at 225°"
let roundaboutLeft270: String = "70" //"Roundabout exit at 270°"
let roundaboutLeft315: String = "71" //"Roundabout exit at 315°"

//Right Hand Driving
let roundaboutRight45: String = "58" //"Roundabout exit at 45°"
let roundaboutRight90: String = "59" //"Roundabout exit at 90°"
let roundaboutRight135: String = "60" //"Roundabout exit at 135°"
let roundaboutRight180: String = "61" //"Roundabout exit at 180°"
let roundaboutRight225: String = "62" //"Roundabout exit at 225°"
let roundaboutRight270: String = "63" //"Roundabout exit at 270°"
let roundaboutRight315: String = "64" //"Roundabout exit at 315°"
let rightUturn: String = "6"

struct directionSymbole {
    let direction: String
}

extension directionSymbole {
    init(directions: String) throws {
        var direction = String()
        switch directions {
        case turnLeft, turnLeftIntersection, turnLeftEnd, takeLeft, takeLeftCurve:
            direction = "I"
        case turnRight, turnRightIntersection, turnRightEnd, takeRight, takeRightCurve:
            direction = "J"
        case turnSlightLeft:
            direction = "C"
        case turnSlightRight:
            direction = "D"
        case turnSharpLeft, sharpLeft:
            direction = "E"
        case turnSharpRight, sharpRight:
            direction = "F"
        case straight, staySameRd, headNorth:
            direction = "G"
        case keepLeft:
            direction = "Z"
        case forkRight:
            direction = "X"
        case rampLeft, takeRampLeft:
            direction = "K"
        case rampRight:
            direction = "L"
        case roundaboutLeft45, roundaboutLeft90, roundaboutLeft135, roundaboutLeft180, roundaboutLeft225, roundaboutLeft270, roundaboutLeft315:
            direction = "U"
        case roundaboutRight45, roundaboutRight90, roundaboutRight135, roundaboutRight180, roundaboutRight225, roundaboutRight270, roundaboutRight315:
            direction = "N"
        case rightUturn:
            direction = "O"
        case uturnRight:
            direction = "P"
        case forkLeft:
            direction = "Q"
        case keepRight:
            direction = "R"
        case ferry:
            direction = "Y"
        case ferryTrain:
            direction = "T"
        case destinationReached:
            direction = "H"
        case wrongWayNE, wrongWayE, wrongWayS, wrongWayW, wrongWayNW, wrongWaySW, wrongWaySE, wrongWayRotary:
            direction = "B"
        default: break
        }
        self.direction = direction
    }
}

/********* show the DirectionBlinkSymbole to BLE Decive all the direction has the some unique code to display  *********/
struct directionBlinkSymbole {
    let directionBlink: String
}

//MARK: -
extension directionBlinkSymbole {
    init(directions: String) throws {
        var direction = String()
        switch directions {
        case turnLeft, turnLeftIntersection, turnLeftEnd, takeLeft, takeLeftCurve:
            direction = "i"
        case turnRight, turnRightIntersection, turnRightEnd, takeRight, takeRightCurve:
            direction = "j"
        case turnSlightLeft:
            direction = "c"
        case turnSlightRight:
            direction = "d"
        case turnSharpLeft, sharpLeft:
            direction = "e"
        case turnSharpRight, sharpRight:
            direction = "f"
        case straight, staySameRd, headNorth:
            direction = "g"
        case keepLeft:
            direction = "z"
        case forkRight:
            direction = "x"
        case rampLeft, takeRampLeft:
            direction = "k"
        case rampRight:
            direction = "l"
        case roundaboutLeft45, roundaboutLeft90, roundaboutLeft135, roundaboutLeft180, roundaboutLeft225, roundaboutLeft270, roundaboutLeft315:
            direction = "u"
        case roundaboutRight45, roundaboutRight90, roundaboutRight135, roundaboutRight180, roundaboutRight225, roundaboutRight270, roundaboutRight315:
            direction = "n"
        case rightUturn:
            direction = "o"
        case uturnRight:
            direction = "p"
        case forkLeft:
            direction = "q"
        case keepRight:
            direction = "r"
        case ferry:
            direction = "y"
        case ferryTrain:
            direction = "t"
        case destinationReached:
            direction = "h"
        case wrongWayNE, wrongWayE, wrongWayS, wrongWayW, wrongWayNW, wrongWaySW, wrongWaySE, wrongWayRotary:
            direction = "b"
        default: break
        }
        self.directionBlink = direction
    }
}
