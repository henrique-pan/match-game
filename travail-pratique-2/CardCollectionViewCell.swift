//
//  CardCollectionViewCell.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card? {
        didSet {
            guard let card = card else { return }
            frontImageView.image = card.image
        }
    }
    
    func showCard(shouldShow: Bool, animated: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        card!.shown = shouldShow
        
        if animated {
            if shouldShow {
                UIView.transition(from: backImageView, to: frontImageView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])
            } else {
                UIView.transition(from: frontImageView, to: backImageView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])
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

