//
//  MatchGame.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import Foundation
import UIKit

class MatchGame {
    
    private static var cardImages:[UIImage] = [UIImage(named: "mouton")!, UIImage(named: "cheval")!,
                                                UIImage(named: "ane")!,    UIImage(named: "poule")!,
                                                UIImage(named: "vache")!,  UIImage(named: "canard")!];
    
    var cards:[Card] = [Card]()
    var delegate: MatchGameDelegate?
    
    fileprivate var shownCards:[Card] = [Card]()
    
    func newGame() {
        cards = randomCards(images: MatchGame.cardImages)
        delegate?.matchGameDidStart(matchGame: self)
    }
    
    func stopGame() {
        cards.removeAll()
        shownCards.removeAll()
    }
    
    func didSelectCard(selectedCard: Card) {
        delegate?.show(card: selectedCard, matchGame: self)
        
        if shownCards.count % 2 != 0 {
            let singleCard = shownCards.last!
            if selectedCard.equalsTo(card: singleCard) {
                shownCards.append(selectedCard)
            } else {
                let differentCard = shownCards.removeLast()
                
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.hide(cards:[selectedCard, differentCard], matchGame: self)
                }
            }
        } else {
            shownCards.append(selectedCard)
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
    
    fileprivate func randomCards(images:[UIImage]) -> [Card] {
        var cards = [Card]()
        for (index, image) in images.enumerated() {
            let id = index * 2
            let card: Card = Card.init(id: id , image: image)
            let pair: Card = Card.init(id: (id+1), card: card)
            cards.append(contentsOf: [card, pair])
        }
        cards.shuffle()
        return cards
    }
    
}

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


