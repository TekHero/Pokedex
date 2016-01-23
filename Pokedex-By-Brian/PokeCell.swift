//
//  PokeCell.swift
//  Pokedex-By-Brian
//
//  Created by Brian Lim on 1/18/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var thumbImg:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    
    // This will hold the pokemon that is passed in when a cell is configured
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        // Setting the nameLbl's text to the name of the pokemon + capitalizing the first letter
        self.nameLbl.text = self.pokemon.name.capitalizedString
        // Setting the thumbImg's image to a image name that is equal to the pokedexId of the pokemon
        self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
