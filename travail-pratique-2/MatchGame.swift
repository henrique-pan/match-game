//
//  MatchGame.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// Game "Manager": Responsible for the execution of the Game.
class MatchGame {
    
    // Set the media for each animal
    private static var cardsMedia: [CardMedia] = [CardMedia(animalName: "mouton"), CardMedia(animalName: "cheval"),
                                                 CardMedia(animalName: "ane"), CardMedia(animalName: "poule"),
                                                 CardMedia(animalName: "vache"), CardMedia(animalName: "canard")]
    
    var audioPlayer: AVAudioPlayer?
    var cards:[Card] = [Card]()
    var delegate: MatchGameDelegate?
    
    var shownCards:[Card] = [Card]()
    
    var gameIsOver: Bool! = false
    
    func newGame() {
        cards = randomCards(cardsMedia: MatchGame.cardsMedia)
        delegate?.matchGameDidStart(matchGame: self)
    }
    
    func stopGame() {
        cards.removeAll()
        shownCards.removeAll()
    }
    
    func didSelectCard(selectedCard: Card) {
        delegate?.show(card: selectedCard, matchGame: self)
        
        doAnimalNoise(card: selectedCard)
        
        if shownCards.count % 2 != 0 {
            let singleCard = shownCards.last!
            if selectedCard.equalsTo(card: singleCard) {
                shownCards.append(selectedCard)
                
                if cards.count == shownCards.count {
                    print("The game is finished")
                    endGame()
                }
                
            } else {
                let differentCard = shownCards.removeLast()
                
                let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                // Call the delay in asynchronously to the main thread
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.hide(cards:[selectedCard, differentCard], matchGame: self)
                }
            }
        } else {
            shownCards.append(selectedCard)
        }
        
        
    }
    
    // Play the sound of the selected animal
    private func doAnimalNoise(card: Card) {
        let sound = Bundle.main.url(forResource: card.noise, withExtension: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound!)
            guard let player = audioPlayer else {return}
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func cardAt(index: Int) -> Card? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }
    
    func indexFor(card: Card) -> Int? {
        for (index, cardFromArray) in cards.enumerated() {
            if card === cardFromArray {
                return index
            }
        }
        return nil
    }
    
    // Suffle the array of cards
    func randomCards(cardsMedia:[CardMedia]) -> [Card] {
        var cards = [Card]()
        for (index, media) in cardsMedia.enumerated() {
            let id = index * 2
            let card: Card = Card.init(id: id , media: media)
            let pair: Card = Card.init(id: (id+1), card: card)
            cards.append(contentsOf: [card, pair])
        }
        cards.shuffle()
        return cards
    }
    
    func endGame() {
        gameIsOver = true
        delegate?.matchGameDidEnd(matchGame: self)
        
        let sound = Bundle.main.url(forResource: "game-ending", withExtension: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound!)
            guard let player = audioPlayer else {return}
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
}

// Extension to set a new implementation of the shuffle method of the Arrays
extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}


