//
//  LandmarkList.swift
//  LandmarkRecognition
//
//  Created by Muhammet İkbal Yaşar 
//

import UIKit

class Landmark {

    var name: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var description: String = ""
    
    static let allValue: [Landmark] =
    [
        Landmark.init(name: "Maiden's Tower", lat: 41.021122, lon: 29.004111, description: Constants.historicalInfo.maidensTower),
        Landmark.init(name: "Blue Mosque", lat: 41.00541, lon: 28.976814, description: Constants.historicalInfo.blueMosque),
        Landmark.init(name: "Galata Tower", lat: 41.025634, lon: 28.974156, description: Constants.historicalInfo.galataTower),
        Landmark.init(name: "Hagia Sophia", lat: 41.008583, lon: 28.980175, description: Constants.historicalInfo.hagiaSophia),
        Landmark.init(name: "Ortakoy Mosque", lat: 41.047329, lon: 29.026763, description: Constants.historicalInfo.ortakoyMosque),
        Landmark.init(name: "Topkapi Palace", lat: 41.01152, lon: 28.983379, description: Constants.historicalInfo.topkapiPalace),
        Landmark.init(name: "Valens Aqueduct", lat: 41.01586, lon: 28.955911, description: Constants.historicalInfo.valensAqueduct),
        Landmark.init(name: "Dolmabahce Palace", lat: 41.039164, lon: 29.000459, description: Constants.historicalInfo.dolmabahcePalace),
        Landmark.init(name: "Obelisk Of Theodosius", lat: 41.005859, lon: 28.975306, description: Constants.historicalInfo.obeliskOfTheodosius),
        Landmark.init(name: "Dolmabahce Clock Tower", lat: 41.037658, lon: 28.996363, description: Constants.historicalInfo.dolmabahceClockTower)
    
    ]
    
    /*
    override init() {
        super.init()
    }
    */
    
    init(name:String, lat:Double, lon:Double, description:String) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.description = description
    }
    
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.lat = decoder.decodeObject(forKey: "lat") as! Double
        self.lon = decoder.decodeObject(forKey: "lon") as! Double
        self.description = decoder.decodeObject(forKey: "description") as! String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(lat, forKey: "lat")
        coder.encode(lon, forKey: "lon")
        coder.encode(description, forKey: "description")
    }
}
