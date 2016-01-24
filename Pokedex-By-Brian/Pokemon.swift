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
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionTxt: String {
        return _nextEvolutionTxt
    }
    
    var nextEvolutionLevel: String {
        
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
        
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            let result = response.result
            
            // Converting the result.value into json format
            if let json = result.value as? Dictionary<String, AnyObject> {
                // Checking if there is a value for a certain key, is so..store that value into the constant
                if let weight = json["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = json["height"] as? String {
                    self._height = height
                }
                
                if let attack = json["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = json["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                // Checking if there is a value for a certain key, in this case...checking if there are an array of dictionaries
                if let types = json["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    // Checking if there is a value for a key called "name" & storing that value into the constant
                    if let name = types[0]["name"] {
                        // Storing the value of that constant & adding capitalized letters into the _type variable
                        self._type = name.capitalizedString
                    }
                    
                    // Checking if there are more then one type
                    if types.count > 1 {
                        
                        // If so, loop through the types
                        for var x = 1; x < types.count; x++ {
                            // Store the value for key into the constant
                            if let name = types[x]["name"] {
                                // Like before, store the value of that constant & add captitalized letters into the _type variable
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    // If there isnt a type, then set a default value to be nil or ""
                } else {
                    self._type = ""
                }
                
                // Checking if there is a value for key called descriptions in the json data
                if let descArr = json["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                    // Checking if there is a value for key (In this case, its the url) store that value into the url constant
                    if let url = descArr[0]["resource_uri"] {
                        // Converting that url into a NSURL
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")
                        print(nsurl)
                        // Creating another Alamofire request to get data
                        Alamofire.request(.GET, nsurl!).responseJSON(completionHandler: { (response) -> Void in
                            // Store the result of the .GET into the descResult constant
                            let descResult = response.result
                            // Converting the descResult into json format
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                
                                // Checking if there is value for key in the descDict
                                if let description = descDict["description"] as? String {
                                    // Storing the description that is retrieved into the _description variable
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed()
                            
                        })
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = json["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        // Mega is not found - Can't support Mega pokemon right now but the api has mega data
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                print(num)
                                
                                self._nextEvolutionID = num
                                self._nextEvolutionTxt = to
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    
                                    self._nextEvolutionLevel = "\(level)"
                                    print(level)
                                }
                                
                                print("Evolution ID: \(self._nextEvolutionID)")
                                print("Evolution Level: \(self._nextEvolutionLevel)")
                                print("Evolution Txt: \(self._nextEvolutionTxt)")
                            }
                        }
                    }
                }
            }
        }
    }
}