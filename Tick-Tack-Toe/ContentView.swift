//
//  ContentView.swift
//  Tick-Tack-Toe
//
//  Created by Evolve on 22/02/2022.
//

import SwiftUI
// 43:00
struct ContentView: View {
    let columns : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    @State private var moves : [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoarDisabled = false
    var body: some View {
        GeometryReader{geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 5){
                    ForEach(0..<9) {i in
                        ZStack{
                            Circle()
                                .foregroundColor(.red)
                                .opacity(0.5)
                                .frame(width: geometry.size.width/3-15,
                                       height: geometry.size.width/3-15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: i) {return}
                            moves[i] = Move(player: .human, bordIndex: i)
                            isGameBoarDisabled = true
                            // check for win condition or draw
                            if checkWinCondition(for: .human, in: moves){
                                print("Human wins")
                                return
                            }
                            if checkForDraw(in: moves){
                                print("Draw")
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, bordIndex: computerPosition)
                                isGameBoarDisabled = false
                                if checkWinCondition(for: .computer, in: moves){
                                    print("Computer wins")
                                    return
                                }
                                if checkForDraw(in: moves){
                                    print("Draw")
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameBoarDisabled)
            .padding()
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.bordIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool{
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        var playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        var playerPosition = Set(playerMoves.map{$0.bordIndex})
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) {return true}
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
}

enum Player{
    case human, computer
}

struct Move {
    let player: Player
    let bordIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
