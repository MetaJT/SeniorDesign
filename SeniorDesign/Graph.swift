//
//  Graph.swift
//  SeniorDesign
//
//  Created by Steven Janssen on 3/23/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

// Define a structure to represent a coordinate point
struct Point: Hashable {
    let x: Int
    let y: Int
}

// Define a structure to represent a weighted edge between two points
struct Edge: Hashable {
    let source: Point
    let destination: Point
    let weight: Double
}

// Define a class to represent a graph
class Graph {
    var edges: [Edge] = []

    // Add an edge to the graph
    func addEdge(from source: Point, to destination: Point, weight: Double) {
        edges.append(Edge(source: source, destination: destination, weight: weight))
        edges.append(Edge(source: destination, destination: source, weight: weight)) // Assuming undirected graph
    }

    // Perform Dijkstra's algorithm to find the shortest path
    func dijkstra(source: Point, destination: Point) -> [Point: Double] {
        var distances: [Point: Double] = [:] // Stores the shortest distances from source to each point
        var visited: Set<Point> = [] // Set of visited points

        // Initialize distances to infinity except for the source point
        for edge in edges {
            distances[edge.source] = edge.source == source ? 0 : Double.infinity
        }

        while !visited.contains(destination), let minPoint = distances.min(by: { $0.value < $1.value }) {
            let currentPoint = minPoint.key
            let currentDistance = minPoint.value

            // Update distances for neighboring points
            for edge in edges where edge.source == currentPoint {
                let neighbor = edge.destination
                if !visited.contains(neighbor) {
                    let newDistance = currentDistance + edge.weight
                    if newDistance < distances[neighbor, default: Double.infinity] {
                        distances[neighbor] = newDistance
                    }
                }
            }

            visited.insert(currentPoint) // Mark the current point as visited
            distances.removeValue(forKey: currentPoint) // Remove processed point from distances
        }

        return distances
    }
}
