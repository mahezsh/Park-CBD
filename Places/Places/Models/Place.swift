//
//  Place.swift
//  Places
//
//  Created by Macbook on 21/5/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
import CoreLocation

struct Place: Codable {
    let computedRegionEvbiJbp8, bayID, lat: String
    let location: Location
    let lon, stMarkerID: String
    let status: Status
    
    enum CodingKeys: String, CodingKey {
        case computedRegionEvbiJbp8 = ":@computed_region_evbi_jbp8"
        case bayID = "bay_id"
        case lat, location, lon
        case stMarkerID = "st_marker_id"
        case status
    }
    
    
    var locationx: CLLocation {
        let xla = (self.lat as NSString).doubleValue
        let xlo = (self.lon as NSString).doubleValue
        return CLLocation(latitude: xla, longitude: xlo)
    }
    
    func distance(to locationx: CLLocation) -> CLLocationDistance {
        return locationx.distance(from: self.locationx)
    }
    
}

struct Location: Codable {
    let latitude, longitude: String
    let humanAddress: HumanAddress
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case humanAddress = "human_address"
    }
}

enum HumanAddress: String, Codable {
    case addressCityStateZip = "{\"address\": \"\", \"city\": \"\", \"state\": \"\", \"zip\": \"\"}"
}

enum Status: String, Codable {
    case present = "Present"
    case unoccupied = "Unoccupied"
}

typealias Welcome = [Place]
