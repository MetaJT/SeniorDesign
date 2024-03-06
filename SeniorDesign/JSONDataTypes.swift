//
//  JSONDataTypes.swift
//  SeniorDesign
//
//  Created by Steven Janssen on 3/5/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

struct Geometry: Codable {
    var coordinates: [Double] = []
}

struct AnchorB: Codable {
    var id:String = ""
    var geometry:Geometry
}

struct MainAnchor: Codable {
    var features:[AnchorB] = []
}

struct NameProp: Codable {
    var en:String = ""
}

struct Property: Codable {
    var anchor_id:String = ""
    var website:String = ""
    var name:NameProp
}

struct OccupantB: Codable {
    var properties:Property
}

struct MainOccupant:Codable {
    var features:[OccupantB] = []
}
