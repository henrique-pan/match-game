//
//  Card.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import Foundation
import UIKit

// Entity that represents each card
class Card {
    
    var id: Int!
    var shown:Bool = false
    var image:UIImage
    var pairId: Int
    
    var noise: String!
    
    // Constructor to a new card
    init(id: Int, media:CardMedia) {
        self.id = id
        self.image = media.image
        self.pairId = id
        self.noise = media.sound
    }
    
    // Constructor to copy an existent card
    init(id: Int, card:Card) {
        self.id = id
        self.shown = card.shown
        self.image = card.image
        self.pairId = card.pairId
        self.noise = card.noise
    }
    
    var stringValue: String {
        return "Card(id:\(id!), shown:\(shown), pairId:\(pairId))"
    }
    
    // Compare the cards: If the "pairId" is equal, the cards make a pair
    func equalsTo(card: Card) -> Bool {
        return (card.pairId == pairId)
    }
}
