//
//  ContentView.swift
//  A02
//
//  Created by นายธนภัทร สาระธรรม on 14/2/2567 BE.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = NumberModel()
    @State private var showingWinAlert = false

    var body: some View {
        VStack {
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .overlay(
                    AspectVGrid(items: viewModel.cards, aspectRatio: 1 ) { card in
                        CardView(card: card, onSlideGesture: {
                            viewModel.slide(card)
                            if viewModel.checkWin() {
                                showingWinAlert = true
                            }
                        })
                        .padding(5)
                        .animation(.default, value: viewModel.cards)
                    }
                    .foregroundColor(.blue)
                )
                .padding()
            
            Spacer()
            
            LazyVGrid(columns: [GridItem()]) {
                Button("New Game") {
                    viewModel.shuffle()
                }
                .foregroundColor(.green)
            }
            
            Text("Move: \(viewModel.moveCount)")
                .foregroundColor(.yellow)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .alert(isPresented: $showingWinAlert) {
            Alert(title: Text("Congratulations!"),
                  message: Text("You won the game in \(viewModel.moveCount) moves!"),
                  dismissButton: .default(Text("New Game")) {
                    viewModel.shuffle()
                    showingWinAlert = false
                  })
        }
    }
}



struct CardView: View {
    var card: GameModel<String>.Card
    var onSlideGesture: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .stroke(Color.black, lineWidth: 2)
            .foregroundColor(.white)
            .overlay(
                Text(card.content)
            )
            .frame(width: 50, height: 50)
            .onTapGesture {
                onSlideGesture()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
