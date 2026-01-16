//
//  ContentView.swift
//  Concentration
//
//  Created by Kiran Shrestha on 1/16/26.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    let tileBack = "⚪️"
    @State private var totalGuesses = 0
    @State private var gameMessage = ""
    @State private var tiles = ["🚀", "🌶️", "🦅", "🐢", "🦋", "🌮", "🍕", "🦄"]
    @State private var emojiShowing = Array(repeating: false, count: 16)
    @State private var guesses : [Int] = []
    @State private var disableButtons = false
    @State private var audioPlayer : AVAudioPlayer!
    
    var body: some View {
        VStack {
            Text("Total Guesses: \(totalGuesses)")
                .font(.largeTitle)
                .fontWeight(.black)
            
            Spacer()
            
            VStack {
                HStack{
                    ForEach(0..<4) { index in
                        Button(emojiShowing[index] == false ? tileBack : tiles[index]) {
                            buttonTapped(index: index)
                        }
                    }
                }
                HStack{
                    ForEach(4..<8) { index in
                        Button(emojiShowing[index] == false ? tileBack : tiles[index]) {
                            buttonTapped(index: index)
                        }
                    }
                }
                HStack{
                    ForEach(8..<12) { index in
                        Button(emojiShowing[index] == false ? tileBack : tiles[index]) {
                            buttonTapped(index: index)
                        }
                    }
                }
                HStack{
                    ForEach(12..<16) { index in
                        Button(emojiShowing[index] == false ? tileBack : tiles[index]) {
                            buttonTapped(index: index)
                        }
                    }
                }
            }
            .font(.largeTitle)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.white)
            .disabled(disableButtons)
            
            Text(gameMessage)
                .font(.largeTitle)
                .frame(height: 80)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
            
            Spacer()
            
            VStack {
                if guesses.count == 2 {
                    if emojiShowing.contains(false) {
                        Button("Another Try?") {
                            //TODO: Action
                            if !(tiles[guesses[0]] == tiles[guesses[1]]) {
                                emojiShowing[guesses[0]] = false
                                emojiShowing[guesses[1]] = false
                            }
                            guesses.removeAll()
                            disableButtons = false
                            gameMessage = ""
                        }
                        .font(.title)
                        .buttonStyle(.glassProminent)
                        .tint(tiles[guesses[0]] == tiles[guesses[1]] ? .mint : .red)
                    }
                    else {
                        Button("Try Again?"){
                            disableButtons = false
                            guesses.removeAll()
                            gameMessage = ""
                            emojiShowing = Array(repeating: false, count: 16)
                            totalGuesses = 0
                            tiles.shuffle()
                        }
                        .font(.title)
                        .buttonStyle(.glassProminent)
                        .tint(.orange)
                    }
                    
                }
            }
            .frame(height: 80)
        }
        .padding()
        .onAppear {
            tiles = tiles + tiles
            tiles.shuffle()
        }
    }
    
    func checkForMatch(){
        if emojiShowing.contains(false) { //Keep guessing
            if tiles[guesses[0]] == tiles[guesses[1]] {
                gameMessage = "✅ You Found a Match!"
                playSound("correct")
            }else {
                gameMessage = "❌ Not A Match. Try Again."
                playSound("wrong")
            }
        }
        else { //guessed all
            gameMessage = "You Guessed Them All!"
            playSound("ta-da")
        }
        
    }
    
    func buttonTapped(index: Int) {
        if !emojiShowing[index] {
            emojiShowing[index] = true
            totalGuesses += 1
            guesses.append(index)
            playSound("tile-flip")
            if guesses.count == 2 {
                disableButtons = true
                checkForMatch()
            }
        }
    }
    
    func playSound(_ soundName: String){
        if audioPlayer != nil, audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("Error trying to playSound: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
