//
//  Card.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    var id: Int!
    var shown:Bool = false
    var image:UIImage
    var pairId: Int
    
    init(id: Int, image:UIImage) {
        self.id = id
        self.image = image
        self.pairId = id
    }
    
    init(id: Int, card:Card) {
        self.id = id
        self.shown = card.shown
        self.image = card.image
        self.pairId = card.pairId
    }
    
    var stringValue: String {
        return "Card(id:\(id!), shown:\(shown), pairId:\(pairId))"
    }
    
    func equalsTo(card: Card) -> Bool {
        return (card.pairId == pairId)
    }
}
