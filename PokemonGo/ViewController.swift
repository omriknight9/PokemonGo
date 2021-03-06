//
//  ViewController.swift
//  PokemonGo
//
//  Created by Omri Shalev on 22/08/2017.
//  Copyright © 2017 Omri Shalev. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    var manager = CLLocationManager()
    
    var pokemons: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
        
        setup()
        
        }else {
            manager.requestWhenInUseAuthorization()
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    func setup() {
        
            mapView.delegate = self
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                
                if let coord = self.manager.location?.coordinate {
                    
                    let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                    let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                    
                    let randoLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    let randoLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    
                    anno.coordinate.latitude += randoLat
                    anno.coordinate.longitude += randoLon
                    self.mapView.addAnnotation(anno)
                }
                
            })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        
        var frame = annoView.frame
        
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
            frame.size.height = 35
            frame.size.width = 35
            annoView.frame = frame
            
        }else {
            let pokemon = (annotation as! PokeAnnotation).pokemon
            annoView.image = UIImage(named: pokemon.imageName!)
            
            frame.size.height = 35
            frame.size.width = 35
            annoView.frame = frame
        }

        return annoView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 3 {
            let reagion = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(reagion, animated: false)
            updateCount += 1
        }else {
            manager.stopUpdatingLocation()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        
        if view.annotation! is MKUserLocation {
            return
        }
        let reagion = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(reagion, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats", message: "\(pokemon.name!) was caught!", preferredStyle: .alert)
                    
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    
                    alertVC.addAction(pokedexAction)
                    
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                }else {
                    let alertVC = UIAlertController(title: "Uh-Oh", message: "\(pokemon.name!) is to far away. Move closer to it", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
        
    }

    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let reagion = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(reagion, animated: true)
        }
        
    }
}

