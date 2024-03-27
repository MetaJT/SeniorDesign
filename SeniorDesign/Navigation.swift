//
//  Navigation.swift
//  SeniorDesign
//
//  Created by Steven Janssen on 3/26/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation
import CoreLocation

struct MyPoint {
    var x: Double
    var y: Double
}

// Define a structure to represent a line segment (with endpoints)
struct Line {
    var start: MyPoint
    var end: MyPoint
}

let MAP_COORDINATES = [
        Line(start: MyPoint(x: 37.68119, y: -97.27576), end: MyPoint(x: 37.68119, y: -97.27412)),
        Line(start: MyPoint(x: 37.68107, y: -97.27552),
        end: MyPoint(x: 37.68125, y: -97.27552)),

        Line(start: MyPoint(x: 37.68126, y: -97.27457),
        end: MyPoint(x: 37.68115, y: -97.27457)),
    

        Line(start: MyPoint(x: 37.68127, y: -97.27462),
        end: MyPoint(x: 37.68127, y: -97.27453)),
    

        Line(start: MyPoint(x: 37.68133, y: -97.27455),
        end: MyPoint(x: 37.68126, y: -97.27455)),
    
    
        Line(start: MyPoint(x: 37.68133, y: -97.27460),
        end: MyPoint(x: 37.68133, y: -97.27453)),
    
]

func convertToPoint(p: CLLocationCoordinate2D) -> MyPoint {
    return MyPoint(x: p.latitude, y: p.longitude)
}

func convertToCoord(p: MyPoint) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: p.x, longitude: p.y)
}

// Function to calculate the Euclidean distance between two points
func distanceBetween(_ point1: MyPoint, _ point2: MyPoint) -> Double {
    let dx = point2.x - point1.x
    let dy = point2.y - point1.y
    return sqrt(dx * dx + dy * dy)
}

// Function to find the closest line to a given point
func closestLine(to point: MyPoint, lines: [Line]) -> Line? {
    guard !lines.isEmpty else { return nil }
    
    var closestLine: Line?
    var minDistance = Double.infinity
    
    for line in lines {
        // Calculate the distance between the point and the line segment
        let distance = distanceToLine(point, line)
        
        // Update closestLine if the current line is closer
        if distance < minDistance {
            minDistance = distance
            closestLine = line
        }
    }
    
    return closestLine
}

// Function to calculate the distance between a point and a line segment
func distanceToLine(_ point: MyPoint, _ line: Line) -> Double {
    let dx = line.end.x - line.start.x
    let dy = line.end.y - line.start.y
    
    // Calculate the square of the line's length
    let lineLengthSquared = dx * dx + dy * dy
    
    // Avoid division by zero
    guard lineLengthSquared != 0 else {
        return distanceBetween(point, line.start)  // MyPoint coincides with start of line
    }
    
    // Calculate the parameter t along the line where the closest point lies
    let t = max(0, min(1, ((point.x - line.start.x) * dx + (point.y - line.start.y) * dy) / lineLengthSquared))
    
    // Calculate the closest point on the line
    let closestMyPoint = MyPoint(x: line.start.x + t * dx, y: line.start.y + t * dy)
    
    // Calculate and return the distance between the point and the closest point on the line
    return distanceBetween(point, closestMyPoint)
}
