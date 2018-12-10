//
//  Model.swift
//  Library
//
//  Created by Benjamin Hakes on 12/10/18.
//  Copyright © 2018 Benjamin Hakes. All rights reserved.
//

import Foundation

class Model {
    static let shared = Model()
    private init() {}
    var delegate: ModelUpdateClient?
    
    typealias UpdateHandler = () -> Void
    var updateHandler: UpdateHandler? = nil
    
    private var pokemons: [Pokemon] = []
    
    func count() -> Int {
        return pokemons.count
    }
    
    func pokemon(forIndex index: Int) -> Pokemon {
        print(index)
        return pokemons[index]
    }
    
    func movePokemon(from index: Int, to destinationIndex: Int) {
        let pokemon = pokemons.remove(at: index)
        pokemons.insert(pokemon, at: destinationIndex)
    }
    
    func setPokemon(pokemons: [Pokemon]) {
        Model.shared.pokemons = pokemons
    }
    
    // MARK: Core Database Management Methods
    
    
    func addNewPokemon(pokemon: Pokemon, completion: @escaping () -> Void) {
        
        // append it to our devices array, updating our local model <-- local
        pokemons.append(pokemon)
        
        // save it by pushing it to the firebase thing <-- remote
        Firebase<Pokemon>.save(item: pokemon){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        delegate?.modelDidUpdate()
    }
    
    func deletePokemon(at indexPath: IndexPath, completion: @escaping () -> Void) {
        //
        let pokemon = pokemons[indexPath.row]
        
        //
        pokemons.remove(at: indexPath.row)
        
        // remote
        Firebase<Pokemon>.delete(item: pokemon){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        
    }
    
    
    func updatePokemon(for pokemon: Pokemon, completion: @escaping () -> Void) {
        //
        
        // TODO: do we need this?
        //device.uuid = UUID().uuidString
        
        // remote
        Firebase<Pokemon>.save(item: pokemon){ success in
            guard success else {return}
            DispatchQueue.main.async { completion()}
        }
        delegate?.modelDidUpdate()
    }
    
    // MARK: Core Search Functionality
    
    func search(for string: String, completion: @escaping () -> Void) {
        Pokeapi.searchForPokemon(with: string) { results, error in
            if let error = error {
                NSLog("Error fetching Pokemon: \(error)")
                return
            }
            
            // Great opportunity to use nil coalescing to convert
            // a nil result into the empty array
            // TODO: Update here
            
            self.results = results ?? []
        }
    }
    
    var results: [Pokemon] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateHandler?()
            }
        }
    }
    
    func numberOfResults() -> Int {
        return results.count
    }
    
    func result(at index: Int) -> Pokemon {
        return results[index]
    }
    
    func deleteResults(){
        results = []
    }
    
}
