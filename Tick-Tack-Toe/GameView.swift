//
//  ContentView.swift
//  Tick-Tack-Toe
//
//  Created by Evolve on 22/02/2022.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        GeometryReader{geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5){
                    ForEach(0..<9) {i in
                        ZStack{
                            GameSquareView(geometry: geometry)
                            PlayerIndicator(systemImagename: viewModel.moves[i]?.indicator ?? "")   
                        }
                        .onTapGesture {
                            viewModel.processPlayerMode(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
        }
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

struct GameSquareView: View{
    var geometry: GeometryProxy
    var body: some View{
        Circle()
            .foregroundColor(.red)
            .opacity(0.5)
            .frame(width: geometry.size.width/3-15,
                   height: geometry.size.width/3-15)
    }
}

struct PlayerIndicator: View{
    var systemImagename: String
    var body: some View{
        Image(systemName: systemImagename)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
