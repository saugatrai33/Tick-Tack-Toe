//
//  GameViewModel.swift
//  Tick-Tack-Toe
//
//  Created by Evolve on 01/03/2022.
//

import SwiftUI

final class GameViewModel: ObservableObject{
    let columns : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    @Published var moves : [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    
    func processPlayerMode(for position: Int){
        if isSquareOccupied(in: moves, forIndex: position) {return}
        moves[position] = Move(player: .human, bordIndex: position)
        isGameBoardDisabled = true
        // check for win condition or draw
        if checkWinCondition(for: .human, in: moves){
            print("Human wins")
            return
        }
        if checkForDraw(in: moves){
            print("Draw")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, bordIndex: computerPosition)
            isGameBoardDisabled = false
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
