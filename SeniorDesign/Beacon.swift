//
//  Beacon.swift
//  SeniorDesign
//
//  Created by Steven Janssen on 4/10/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

struct Beacon {
    var uuid: String
    var majorId: UInt16
    var minorId: UInt16
    var x: Double
    var y: Double
    var z: Double
    var distance: Double
}

struct Point3D {
    var x: Double
    var y: Double
    var z: Double
}

// UPDATE THESE WHENEVER NEW BEACONS GET ADDED
var BEACONS_LIST = [
    Beacon(uuid: "1B6295D5-4F74-4C58-A2D8-CD83CA26BDF4", majorId: 3838, minorId: 4949, x: 0, y: 0*2, z: 0, distance: 0),
    Beacon(uuid: "1B6295D5-4F74-4C58-A2D8-CD83CA26BDF4", majorId: 3838, minorId: 4950, x: 0, y: 0*2, z: 0, distance: 0),
    Beacon(uuid: "1B6295D5-4F74-4C58-A2D8-CD83CA26BDF4", majorId: 3838, minorId: 4951, x: 0, y: 0*2, z: 0, distance: 0),
    Beacon(uuid: "1B6295D5-4F74-4C58-A2D8-CD83CA26BDF5", majorId: 3838, minorId: 4950, x: 0, y: 0*2, z: 0, distance: 0),
    Beacon(uuid: "1B6295D5-4F74-4C58-A2D8-CD83CA26BDF6", majorId: 3838, minorId: 4949, x: 0, y: 0*2, z: 0, distance: 0),
]

func trilaterate(knownPoints: [Point3D], distances: [Double]) -> Point3D? {
    guard knownPoints.count >= 3 && distances.count >= 3 else {
//        print("Error: Insufficient data for trilateration")
        return nil
    }
    
    var totalError = 0.0
    let userCoords = [0.0, 0.0, 0.0]
    for i in 0..<knownPoints.count {
        let distance = sqrt(pow(knownPoints[i].x - userCoords[0], 2) +
                            pow(knownPoints[i].y - userCoords[1], 2) +
                            pow(knownPoints[i].z - userCoords[2], 2))
        totalError += pow(distance - distances[i], 2)
    }
    
    // Extract user's coordinates
    
    return Point3D(x: userCoords[0], y: userCoords[1], z: userCoords[2])
}
