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
    Beacon(uuid: "1B6295D5-4F74-4C58-A2D8-CD83CA26BDF5", majorId: 3838, minorId: 4950, x: 0, y: 0*2, z: 0, distance: 0),
    Beacon(uuid: "1B6295D5-4F74-4C58-A2D8-CD83CA26BDF6", majorId: 3838, minorId: 4949, x: 0, y: 0*2, z: 0, distance: 0),
]

func trilaterate(knownPoints: [Point3D], distances: [Double]) -> Point3D? {
    guard knownPoints.count >= 3 && distances.count >= 3 else {
        print("Error: Insufficient data for trilateration")
        return nil
    }
    
    // Objective function for optimization (minimize sum of squared errors)
    func errorFunction(userCoords: [Double]) -> Double {
        var totalError = 0.0
        for i in 0..<knownPoints.count {
            let distance = sqrt(pow(knownPoints[i].x - userCoords[0], 2) +
                                pow(knownPoints[i].y - userCoords[1], 2) +
                                pow(knownPoints[i].z - userCoords[2], 2))
            totalError += pow(distance - distances[i], 2)
        }
        return totalError
    }
    
    // Initial guess for user's coordinates
    let initialGuess = [0.0, 0.0, 0.0]
    
    // Perform optimization using Nelder-Mead algorithm
    let result = minimize(objectiveFunction: errorFunction, initialGuess: initialGuess)
    
    // Extract user's coordinates
    guard let userCoords = result else {
        print("Error: Optimization failed")
        return nil
    }
    
    return Point3D(x: userCoords[0], y: userCoords[1], z: userCoords[2])
}

// Placeholder for optimization function
func minimize(objectiveFunction: ([Double]) -> Double, initialGuess: [Double]) -> [Double]? {
    // Implement optimization algorithm here (e.g., Nelder-Mead)
    // Placeholder implementation returns initial guess
    return initialGuess
}
