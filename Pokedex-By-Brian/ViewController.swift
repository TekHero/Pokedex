//
//  ViewController.swift
//  Pokedex-By-Brian
//
//  Created by Brian Lim on 1/18/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    // By default, searchMode is off
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        // Setting the searchBar keyboard to have a done key instead of the normal search key
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio() {
        // Getting the path of the background music file & storing it in the constant
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        do {
            // Assigning the musicPlayer to play the music url
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            // Setting the number of loops to -1 causes it to repeat forever
            musicPlayer.numberOfLoops = -1
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        // Getting the path of the pokemon.csv file & storing it in the constant
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            // Storing the contents of the CSV into the constant
            let csv = try CSV(contentsOfURL: path)
            // storing the rows of the CSV contents into the constant
            let rows = csv.rows
            // For in loop, for every row in the rows constant, do something
            for row in rows {
                // Store the id that goes along with the key "id" into the constant
                let pokeId = Int(row["id"]!)!
                // Store the name that goes along with the key "identififier" into the constant
                let name = row["identifier"]!
                // Creating a new pokemon & passing in the data that was parsed out (Name & Pokedex ID)
                let poke = Pokemon(name: name, pokedexId: pokeId)
                // Adding the new pokemon into the pokemon arrray
                pokemon.append(poke)
            }
            // Catch any errors that may occur
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // -----------Collection View Delegate Functions------------ //
    
    // Called when a cell is needed
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            // Checking to see if searchMode is on
            if inSearchMode {
                // If so, store the current index of the filteredPokemon array into poke
                poke = filteredPokemon[indexPath.row]
            } else {
                // If not, store the current index of the regular pokemon array into poke
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
        
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke: Pokemon!
        
        // Checking is searchMode is on
        if inSearchMode {
            // If so, store the current index of the filteredPokemon into the poke constant
            poke = filteredPokemon[indexPath.row]
        } else {
            // If not, store the current index of the regular pokemon array into the poke constant
            poke = pokemon[indexPath.row]
        }
        
        // Perform the segue but also send the poke object too
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Checking to see if searchMode is on
        if inSearchMode {
            // if so, return the count of the filteredPokemon array
            return filteredPokemon.count
        }
        // If not in searchMode, return the count of the normal pokemon array
        return pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // The size of the collection cell
        return CGSizeMake(105, 105)
    }
    
    // ----------------------------------------------------- //

    @IBAction func musicBtnPressed(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            // If the music is playing, stop it & set the alpha of the button be faded
            sender.alpha = 1.0
        } else {
            musicPlayer.play()
            // If the music is not playing, play it & set the alpha of the button to be fully opaque
            sender.alpha = 0.2
        }
    }
    
    // If the x button in the search bar is tapped, the keyboard is dismissed
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            // Storing the searchBar's text & converting it into lowercase letters then storing that into the constant
            let lower = searchBar.text!.lowercaseString
            // The $0.name.rangeOfString(lower) != nil syntax means that its gonna grab every pokemon in the array
            // Grab that pokemons name & check if the name has certain characters that the user typed in
            // Making sure its not nil, whatever is not nil, pass it into the filteredPokemon array
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            // Reload the collection view data
            collection.reloadData()
        }
    }
    
    // This is called before the segue actually happens
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Checking to see if the segue's identifier is equal to a certain name
        if segue.identifier == "PokemonDetailVC" {
            // Checking to see if the segue's destination is the PokemonDetailVC, if so, store PokemonDetailVC into the detailsVC constant
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                // Checking to see if there is something in the sender, if so...store whatever is in there, into the poke constant
                if let poke = sender as? Pokemon {
                    // Setting the pokemon variable thats in the PokemonDetailVC to the poke constant
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
}

