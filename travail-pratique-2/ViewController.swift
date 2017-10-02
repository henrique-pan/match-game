//
//  ViewController.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import UIKit


// Main ViewController of the application
class ViewController: UIViewController {
    
    let NUMBER_OF_SECTIONS = 1
    let NUMBER_OF_ITEMS_IN_SECTION = 12
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    
    // Instance of the Game "Manager"
    let matchGame = MatchGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
        */
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        print("Setting initial dimesions")
        // Allow the forced update of constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        setCollectionViewDimensions()
        
        // Set the ViewController as implamentation of the delegate pattern
        matchGame.delegate = self
        // Starts a new game
        matchGame.newGame()
    }
    
    // If the device rotate
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setCollectionViewDimensions()
    }
    
    // Private function to define new constraints for the cards and reset button
    private func setCollectionViewDimensions() {
        let orient = UIApplication.shared.statusBarOrientation
        
        if (orient.isPortrait) {
            print("Portrait")
            // Set the proportion related to the view width
            let width = self.view.frame.width * 0.85
            let height = width
            
            let x = (self.view.frame.width - width) / 2
            let y = (self.view.frame.height - width) / 2
            
            collectionView.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            print("LandScape")
            // Set the proportion related to the view width
            let width = self.view.frame.width * 0.60
            let height = width
            
            let x = (self.view.frame.width - width) / 2
            let y = (self.view.frame.height - width) / 2
            
            collectionView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        collectionView.reloadData()
    }
    
    // Reset button action: reset the game
    @IBAction func resetGame(_ sender: UIButton) {
        matchGame.gameIsOver = false
        
        matchGame.stopGame()
        matchGame.newGame()
        
        collectionView.reloadData()
    }
    
    
}

// Extension of the ViewController for the CollectionView's elements
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_OF_ITEMS_IN_SECTION
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        let cardAtIndex = matchGame.cardAt(index: indexPath.item)!
        
        cell.card = cardAtIndex
        cell.showCard(shouldShow: cardAtIndex.shown, animated: false)
        
        // Cell's Border
        if !self.matchGame.gameIsOver {
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 1
        } else {
            cell.layer.borderColor = UIColor.yellow.cgColor
            cell.layer.shadowColor = UIColor.yellow.cgColor
            cell.layer.borderWidth = 3
        }
        
        
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowRadius = 20.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = true
        // Cell's Border
            
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Ideal proportions to 3 x 4 collection view
        let itemWidth: CGFloat = collectionView.frame.width / 4.0
        let itemHeight: CGFloat = collectionView.frame.height / 4.3
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = matchGame.cardAt(index: indexPath.item)!
        
        if !card.shown {
            matchGame.didSelectCard(selectedCard: card)
            collectionView.deselectItem(at: indexPath, animated:true)
        }
    }
}

// Extension of the ViewController for the delegate pattern with the Game "Manager"
extension ViewController: MatchGameDelegate {
    // "Detects" when the game starts
    func matchGameDidStart(matchGame: MatchGame) {
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
    
    // Show the selected card
    func show(card: Card!, matchGame: MatchGame) {
        let index = matchGame.indexFor(card: card)!
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCollectionViewCell
        cell.showCard(shouldShow: true, animated: true)
    }
    
    // Hide unpaired cards
    func hide(cards: [Card]!, matchGame: MatchGame) {
        for card in cards! {
            if let index = matchGame.indexFor(card: card) {
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCollectionViewCell
                cell.showCard(shouldShow: false, animated: true)
            }
        }
    }
    
    // "Detects" when the game ends
    func matchGameDidEnd(matchGame: MatchGame) {
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.collectionView.reloadData()
        }

        self.animateButton()
    }
    
    private func animateButton() {
        if self.matchGame.gameIsOver {
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 4.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                                self?.resetButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                                self?.resetButton.transform = CGAffineTransform.identity
                           },
                           completion: {_ in
                                self.animateButton()
            })
        }
    }
    
}
