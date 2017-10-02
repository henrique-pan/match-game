//
//  MatchGameDelegate.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import Foundation

protocol MatchGameDelegate {
    
    func matchGameDidStart(matchGame: MatchGame)
    
    func show(card: Card!, matchGame: MatchGame)
    
    func hide(cards: [Card]!, matchGame: MatchGame)
    
    func matchGameDidEnd(matchGame: MatchGame)
    
}
