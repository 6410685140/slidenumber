//
//  ModelGame.swift
//  A02
//
//  Created by นายธนภัทร สาระธรรม on 14/2/2567 BE.
//

import SwiftUI

struct GameModel<CardContent: Equatable> { // Add Equatable constraint
    var cards: [Card]
    var moveCount: Int = 0
    
    init(numberOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = (0..<numberOfCards).map { index in
            Card(id: index, content: cardContentFactory(index))
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func slide(_ card: Card) {
        guard let cardIndex = cards.firstIndex(where: { $0.id == card.id }) else { return }
        let emptyIndex = cards.firstIndex(where: { $0.isContentEmpty }) ?? -1
        
        let distance = emptyIndex - cardIndex

        let validDistances: Set<Int> = [-1, -4, 1, 4]
        guard validDistances.contains(distance) else { return }

        cards.swapAt(cardIndex, emptyIndex)
        moveCount += 1
    }
    
    struct Card: Identifiable, Equatable {
        var id: Int
        var content: CardContent
        var isContentEmpty: Bool {
            if let stringContent = content as? String {
                return stringContent.isEmpty
            }
            return false
        }
    }
}

class NumberModel: ObservableObject {
    
    static var Number1_16 = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11",
                              "12", "13", "14", "15", ""]
    
    @Published private var model = GameModel<String>(numberOfCards: Number1_16.count) { index in
        Number1_16[index]
    }
    
    var cards: [GameModel<String>.Card] {
        return model.cards
    }
    
    var moveCount: Int {
        return model.moveCount
    }
    
    func shuffle() {
        model.shuffle()
        model.moveCount = 0
    }

    func slide(_ card: GameModel<String>.Card) {
        model.slide(card)
    }
    
    func checkWin() -> Bool {
        // Check if the current arrangement of cards is a winning arrangement
        let currentArrangement = model.cards.map { $0.content }
        let winningArrangement = NumberModel.Number1_16
        return currentArrangement == winningArrangement
    }
}
