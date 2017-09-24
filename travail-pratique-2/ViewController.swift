//
//  ViewController.swift
//  travail-pratique-2
//
//  Created by Henrique Nascimento on 2017-09-23.
//  Copyright © 2017 Henrique Nascimento. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let NUMBER_OF_SECTIONS = 1
    let NUMBER_OF_ITEMS_IN_SECTION = 12
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let matchGame = MatchGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        print("Setting initial dimesions")
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        setCollectionViewDimensions()
        
        matchGame.delegate = self
        matchGame.newGame()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setCollectionViewDimensions()
    }
    
    private func setCollectionViewDimensions() {
        let orient = UIApplication.shared.statusBarOrientation
        
        if (orient.isPortrait) {
            print("Portrait")
            let width = self.view.frame.width * 0.85
            let height = width
            
            let x = (self.view.frame.width - width) / 2
            let y = (self.view.frame.height - width) / 2
            
            collectionView.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            print("LandScape")
            let width = self.view.frame.width * 0.60
            let height = width
            
            let x = (self.view.frame.width - width) / 2
            let y = (self.view.frame.height - width) / 2
            
            collectionView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        collectionView.reloadData()
    }
    
    
    @IBAction func resetGame(_ sender: UIButton) {
        matchGame.stopGame()
        matchGame.newGame()
        
        collectionView.reloadData()
    }
    
    
}

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
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowRadius = 20.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = true
        // Cell's Border
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

extension ViewController: MatchGameDelegate {
    func matchGameDidStart(matchGame: MatchGame) {
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
    
    func show(card: Card!, matchGame: MatchGame) {
        let index = matchGame.indexFor(card: card)!
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCollectionViewCell
        cell.showCard(shouldShow: true, animated: true)
    }
    
    func hide(cards: [Card]!, matchGame: MatchGame) {
        for card in cards {
            let index = matchGame.indexFor(card: card)!
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCollectionViewCell
            cell.showCard(shouldShow: false, animated: true)
        }
    }
}
