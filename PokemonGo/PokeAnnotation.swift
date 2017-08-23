//
//  PokeAnnotation.swift
//  PokemonGo
//
//  Created by Omri Shalev on 23/08/2017.
//  Copyright © 2017 Omri Shalev. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
