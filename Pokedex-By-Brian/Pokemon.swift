//
//  Pokemon.swift
//  Pokedex-By-Brian
//
//  Created by Brian Lim on 1/18/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var pokemonURL: String {
        get {
            return _pokemonURL
        } set {
            _pokemonURL = newValue
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/)"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            let result = response.result.value
            print(result)
        }
    }
}