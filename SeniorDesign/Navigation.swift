//
//  Navigation.swift
//  SeniorDesign
//
//  Created by Steven Janssen on 3/26/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation
import CoreLocation

struct MyPoint: Equatable {
    var x: Double
    var y: Double
}

// Define a structure to represent a line segment (with endpoints)
struct Line {
    var start: MyPoint
    var end: MyPoint
}

let MAP_COORDINATES = [
        Line(start: MyPoint(x: 37.68119, y: -97.27576), end: MyPoint(x: 37.68119, y: -97.27412)), // Large horizontal line
        Line(start: MyPoint(x: 37.68107, y: -97.27552),
        end: MyPoint(x: 37.68125, y: -97.27552)), // line by building 3 vertical

        Line(start: MyPoint(x: 37.68126, y: -97.27457),
        end: MyPoint(x: 37.68115, y: -97.27457)),
    

        Line(start: MyPoint(x: 37.68127, y: -97.27462),
        end: MyPoint(x: 37.68127, y: -97.27453)),
    

        Line(start: MyPoint(x: 37.68133, y: -97.27455),
        end: MyPoint(x: 37.68126, y: -97.27455)),
    
    
        Line(start: MyPoint(x: 37.68133, y: -97.27460),
        end: MyPoint(x: 37.68133, y: -97.27453)),
    
]

// Function to calculate the Euclidean distance between two points
func distanceBetween(_ point1: MyPoint, _ point2: MyPoint) -> Double {
    let dx = point2.x - point1.x
    let dy = point2.y - point1.y
    return sqrt(dx * dx + dy * dy)
}

// Function to find the point on the closest line that is closest to a given point
func closestPointOnLine(to point: MyPoint, line: Line) -> MyPoint {
    let lineVector = MyPoint(x: line.end.x - line.start.x, y: line.end.y - line.start.y)
    let pointVector = MyPoint(x: point.x - line.start.x, y: point.y - line.start.y)
    
    let lineLengthSquared = lineVector.x * lineVector.x + lineVector.y * lineVector.y
    let t = max(0, min(1, (pointVector.x * lineVector.x + pointVector.y * lineVector.y) / lineLengthSquared))
    
    let closestPoint = MyPoint(x: line.start.x + t * lineVector.x, y: line.start.y + t * lineVector.y)
    return closestPoint
}

// Function to calculate the intersection point of two lines
func intersectionPoint(line1: Line, line2: Line) -> MyPoint? {
    let x1 = line1.start.x
    let y1 = line1.start.y
    let x2 = line1.end.x
    let y2 = line1.end.y
    
    let x3 = line2.start.x
    let y3 = line2.start.y
    let x4 = line2.end.x
    let y4 = line2.end.y
    
    let denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    
    // Check if the lines are parallel (denominator is zero)
    if abs(denominator) < 0.000000001 {
        return nil  // Lines are parallel, no intersection point
    }
    
    let xNumerator = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)
    let yNumerator = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)
    
    let intersectionX = xNumerator / denominator
    let intersectionY = yNumerator / denominator
    
    return MyPoint(x: intersectionX, y: intersectionY)
}

func convertToCoord(p: MyPoint) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: p.x, longitude: p.y)
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

// Function to calculate the distance between a point and a line segment
func distanceToLinePoint(_ point: MyPoint, _ line: Line) -> MyPoint {
    let dx = line.end.x - line.start.x
    let dy = line.end.y - line.start.y
    
    // Calculate the square of the line's length
    let lineLengthSquared = dx * dx + dy * dy
    
    // Avoid division by zero
    guard lineLengthSquared != 0 else {
        return line.start
    }
    
    // Calculate the parameter t along the line where the closest point lies
    let t = max(0, min(1, ((point.x - line.start.x) * dx + (point.y - line.start.y) * dy) / lineLengthSquared))
    
    // Calculate the closest point on the line
    let closestMyPoint = MyPoint(x: line.start.x + t * dx, y: line.start.y + t * dy)
    return closestMyPoint
}

// Calculate the rest of the points in the navigation
func addOtherCoordinates(startingLine: Line, startingPoint: MyPoint, destinationPoint: MyPoint, checkedIntersections: [MyPoint]) -> [MyPoint]? {
    var ret: [MyPoint] = []
    var ints = checkedIntersections
    // fill the rest of the distance if close enough
    if (distanceBetween(startingPoint, destinationPoint) < 0.00008) {
        ret.append(destinationPoint)
        return ret
    }
    // check if any point on the current line is close enough
    if (distanceToLine(destinationPoint, startingLine) < 0.00008) {
        ret.append(distanceToLinePoint(destinationPoint, startingLine))
        ret.append(destinationPoint)
        return ret
    }
    for line in MAP_COORDINATES {
        guard let intersection = intersectionPoint(line1: line, line2: startingLine) else {
            continue
        }
        if ints.contains(intersection) {
            continue
        }
        ints.append(intersection)
        if (abs(intersection.x - destinationPoint.x) < abs(startingPoint.x - destinationPoint.x)) || (abs(intersection.y - destinationPoint.y) < abs(startingPoint.y - destinationPoint.y)) { // If the intersection point gets us closer to the destination, explore this route
            guard let newCoords = addOtherCoordinates(startingLine: line, startingPoint: intersection, destinationPoint: destinationPoint, checkedIntersections: ints) else {
                continue
            }
            ret.append(intersection)
            for _lol in newCoords {
                ret.append(_lol)
            }
            return ret
        }
    }
    return nil
}
