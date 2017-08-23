//
//  CoreDadaHelp.swift
//  PokemonGo
//
//  Created by Omri Shalev on 22/08/2017.
//  Copyright © 2017 Omri Shalev. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Pikachu", imageName: "pikachu")
    createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
    createPokemon(name: "Charmander", imageName: "charmander")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Squirtle", imageName: "squirtle")
    createPokemon(name: "Abra", imageName: "abra")
    createPokemon(name: "Eevee", imageName: "eevee")
    createPokemon(name: "Bellsprout", imageName: "bellsprout")
    createPokemon(name: "Caterpie", imageName: "caterpie")
    createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
    createPokemon(name: "Mankey", imageName: "mankey")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Rattata", imageName: "rattata")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Venonat", imageName: "venonat")
    createPokemon(name: "Weedle", imageName: "weedle")
    createPokemon(name: "Zubat", imageName: "zubat")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}

func createPokemon(name: String, imageName: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}

func getAllPokemon() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
        }
        
        return pokemons
    } catch {}
    
    return []
    
}

func getAllCaughtPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch{}
    return []
}

func getAllUnCaughtPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch{}
    return []
}









