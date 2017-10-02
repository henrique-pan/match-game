//
//  CardMedia.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-25.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import Foundation
import UIKit

// Entity that represents the media related to each animal
class CardMedia {
    
    var image: UIImage!
    
    var sound: String!
    
    init(animalName: String!) {
        self.image = UIImage(named: animalName)
        self.sound = animalName
    }
    
}
