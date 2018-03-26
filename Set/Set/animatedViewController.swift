//
//  animatedViewController.swift
//  SetGame
//
//  Created by Alon Shprung on 3/25/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class animatedViewController: UIViewController {

    @IBOutlet weak var boardView: UIView!
    
    @IBOutlet weak var scoreLable: UILabel!
    
    @IBAction func DealThreeMoreCards(_ sender: UIButton) {
        handleWhenDealThreeMoreCards()
    }
    
    @IBOutlet weak var dealThreeMoreCardsButton: UIButton!

    private lazy var game = SetGame()
    
    private var cardViews = [CardView]()
    
    private var isMatchOnScreen = false
    
    private var isViewDidLayoutSubviewsNeedToUpdateView = true
    
    private var wasMatchOnScreenOnLastMoveWhenDeckIsEmpty = false
    
    private var matchCardViewsIndexesOnLastMoveWhenDeckIsEmpty = [Int]()
    
    private var matchCardViewsIndexesOnScreen = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for _ in 0..<12 {
            addCardView()
        }
        addGestures()
    }
    
    override func viewDidLayoutSubviews() {
        if isViewDidLayoutSubviewsNeedToUpdateView {
            updateViewFromModel()
            isViewDidLayoutSubviewsNeedToUpdateView = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.updateViewFromModel()
        })
    }
    
    private func addGestures() {
        // swipe up to start a new game
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.startNewGame(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    private func handleWhenDealThreeMoreCards(){
        guard !game.deck.isNoMoreCardsInDeck() else {
            return
        }
        if isMatchOnScreen {
            isMatchOnScreen = false
            for cardViewIndex in matchCardViewsIndexesOnScreen {
                let prefFrame = cardViews[cardViewIndex].frame
                cardViews[cardViewIndex].frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                               delay: 0,
                                                               options: [.curveEaseInOut],
                                                               animations: {self.cardViews[cardViewIndex].alpha = 1},
                                                               completion: {_ in
                                                                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0,
                                                                                                               delay: 0.5,
                                                                                                               options: [.curveEaseInOut],
                                                                                                               animations: {self.cardViews[cardViewIndex].frame = prefFrame}
                                                                )}
                )


            }
        } else {
            game.dealThreeMoreCards()
            if game.deck.isNoMoreCardsInDeck() {
                dealThreeMoreCardsButton.isHidden = true
            }
            for _ in 0..<3 {
                addCardView()
            }
        }
        updateViewFromModel()
    }
    
    fileprivate func updateCardViewsWhenNewGameStarted() {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
        cardViews = [CardView]()
        for _ in 0..<12 {
            addCardView()
        }
    }
    
    @objc func startNewGame(_ sender: UISwipeGestureRecognizer) {
        game.newGame()
        updateCardViewsWhenNewGameStarted()
        dealThreeMoreCardsButton.isHidden = false
        updateViewFromModel()
    }
    
    private func addCardView(){
        let cardView = CardView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cardView.addGestureRecognizer(tap)
        cardView.isFaceUp = false
        
        self.view.addSubview(cardView)

        cardViews.append(cardView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let cardNumber = cardViews.index(of: sender.view as! CardView) else {
            print("choosen card was not in cardButtons")
            return
        }
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    private func handleWhenNoMoreCardsInDeck() {
        wasMatchOnScreenOnLastMoveWhenDeckIsEmpty = true
        for cardViewIndex in matchCardViewsIndexesOnScreen {
            cardViews.remove(at: cardViewIndex)
            matchCardViewsIndexesOnLastMoveWhenDeckIsEmpty.append(cardViewIndex)
        }
    }
    
    private func reArrangeCardViews(){
        let numberOfCards = cardViews.count + 3
        let newGrid = getNewGrid(numberOfCards: numberOfCards)
        for index in cardViews.indices {
            let cardView = cardViews[index]
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2.0,
                                                           delay: 0.5,
                                                           options: [.curveEaseInOut],
                                                           animations: {cardView.frame = newGrid[index]!}
            )
        }
    }
    
    private func updateViewFromModel() {
        let numberOfCards = game.cardsBeingPlayed.count
        let newGrid = getNewGrid(numberOfCards: numberOfCards)
        isMatchOnScreen = false
        matchCardViewsIndexesOnScreen = [Int]()
        for index in game.cardsBeingPlayed.indices {
            let card = game.cardsBeingPlayed[index]
            let cardView = cardViews[index]
            cardView.cardLable.attributedText = getCardAttrString(card)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2.0,
                                                           delay: 0.5,
                                                           options: [.curveEaseInOut],
                                                           animations: {cardView.frame = newGrid[index]!},
                                                           completion: {_ in if !cardView.isFaceUp && !self.isMatchOnScreen { UIView.transition(
                                                            with: cardView,
                                                            duration: 0.5,
                                                            options: [.transitionFlipFromLeft],
                                                            animations: {
                                                                cardView.isFaceUp = !cardView.isFaceUp
                                                                }
                                                            )}
                            })
            showCardSelection(card, cardView)
            showCardMatching(card, cardView)
        }
        if isMatchOnScreen {
            for cardViewIndex in matchCardViewsIndexesOnScreen {
                UIView.transition(
                    with: cardViews[cardViewIndex],
                    duration: 0.5,
                    options: [.transitionFlipFromLeft],
                    animations: {self.cardViews[cardViewIndex].isFaceUp = !self.cardViews[cardViewIndex].isFaceUp}
                )
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                               delay: 3.0,
                                                               options: [.curveEaseInOut],
                                                               animations: {self.cardViews[cardViewIndex].alpha = 0}
                    
                    
                )
            }
            let timeUntilUpdateScreen = game.deck.isNoMoreCardsInDeck() ? 0.6 : 1.5
            view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilUpdateScreen) {
                self.game.updateCardsAfterThreeSelected()
                self.handleWhenDealThreeMoreCards()
                self.view.isUserInteractionEnabled = true
//                self.reArrangeCardViews()
            }
        }
        if game.deck.isNoMoreCardsInDeck() {
            handleWhenNoMoreCardsInDeck()
        }
        
        // update score lable
        scoreLable.text = "Score: \(game.score)"
    }
    
    private func showCardMatching(_ card: Card, _ cardView: CardView) {
        if card.isMatch {
            cardView.cardInternalView.layer.borderWidth = 3.0
            cardView.cardInternalView.layer.borderColor = UIColor.green.cgColor
            isMatchOnScreen = true
            matchCardViewsIndexesOnScreen.append(cardViews.index(of: cardView)!)
        } else if game.selectedCardsIndex.count == 3, card.isSelected {
            cardView.cardInternalView.layer.borderWidth = 3.0
            cardView.cardInternalView.layer.borderColor = UIColor.red.cgColor
            isMatchOnScreen = false
        }
    }
    
    private func getNewGrid(numberOfCards: Int) -> Grid {
        return Grid(layout: Grid.Layout.dimensions(rowCount: numberOfCards / 3, columnCount:  3), frame: boardView.frame)
    }
    
    private func showCardSelection(_ card: Card, _ cardView: CardView) {
        if card.isSelected {
            cardView.cardInternalView.layer.borderWidth = 3.0
            cardView.cardInternalView.layer.borderColor = UIColor.blue.cgColor
        } else {
            cardView.cardInternalView.layer.borderWidth = 0
        }
    }
    
    
    private func getCardAttrString(_ card: Card) -> NSAttributedString {
        let stringAttributes = getNSAttributedStringKeyForShadingAndColor(card: card)
        let buttonTitle = getButtonTitle(card: card)
        return NSAttributedString(string: buttonTitle, attributes: stringAttributes)
    }
    
    private func getButtonTitle(card: Card) -> String {
        var symbol = getSymbol(card: card)
        switch card.number {
        case .one:
            break
        case .two:
            symbol = symbol + " " + symbol
        case .three:
            symbol = symbol + " " + symbol + " " + symbol
        }
        return symbol
    }
    
    private func getSymbol(card: Card) -> String {
        let symbols = ["■","●","▲"]
        switch card.symbol {
        case .symbol0:
            return symbols[0]
        case .symbol1:
            return symbols[1]
        case .symbol2:
            return symbols[2]
        }
    }
    
    private func getCardColor(card: Card) -> UIColor {
        let colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)]
        switch card.color {
        case .color0:
            return colors[0]
        case .color1:
            return colors[1]
        case .color2:
            return colors[2]
        }
    }
    
    private func getNSAttributedStringKeyForShadingAndColor(card: Card) -> [NSAttributedStringKey : Any] {
        let cardColor = getCardColor(card: card)
        
        switch card.shading {
        case .striped:
            return [NSAttributedStringKey.foregroundColor: cardColor.withAlphaComponent(0.15)]
        case .filled:
            return [NSAttributedStringKey.foregroundColor: cardColor.withAlphaComponent(1), NSAttributedStringKey.strokeWidth: -1]
        case .outline:
            return [NSAttributedStringKey.foregroundColor: cardColor.withAlphaComponent(1), NSAttributedStringKey.strokeWidth: 4]
        }
    }
    
    private func handleWhenWasMatchAndDeckIsEmpty() {
        self.wasMatchOnScreenOnLastMoveWhenDeckIsEmpty = false
        for cardViewIndex in self.matchCardViewsIndexesOnLastMoveWhenDeckIsEmpty {
            cardViews[cardViewIndex].removeFromSuperview()
        }
    }
}
