//
//  CardCollectionViewCell.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import UIKit

// CollectionViewCell that represents the cards
class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card? {
        // Set the image on flip
        didSet {
            guard let card = card else { return }
            frontImageView.image = card.image
        }
    }
    
    // Show the card with transitions
    func showCard(shouldShow: Bool, animated: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        card!.shown = shouldShow
        
        if animated {
            if shouldShow {
                UIView.transition(from: backImageView, to: frontImageView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews])
            } else {
                UIView.transition(from: frontImageView, to: backImageView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews])
            }
        } else {
            if shouldShow {
                bringSubview(toFront: frontImageView)
                backImageView.isHidden = true
            } else {
                bringSubview(toFront: backImageView)
                frontImageView.isHidden = true
            }
        }
    }
    
}

