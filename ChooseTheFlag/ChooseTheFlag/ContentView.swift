//
//  ContentView.swift
//  ChooseTheFlag
//
//  Created by Sauvik Dolui on 15/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = [
        "uk", "us", "france", "poland",
        "nigeria", "spain", "italy", "monaco",
        "germany","estonia", "russia", "ireland"
    ].shuffled()
    
    @State private var answerIndex = Int.random(in: 0..<3)
    @State private var score = 0
    @State private var isShowingAlert = false
    @State private var messageTitle = ""

    
    var body: some View {
        NavigationView {
            VStack {
                Text("Current score is: \(score)")
                VStack {
                    ForEach(0..<3) { number in
                        Image(countries[number])
                            .border(Color.black, width: 1)
                            .onTapGesture(count: 1, perform: {
                                self.flagTappedAtIndex(number)
                            })
                    }
                }
            }.navigationTitle(countries[answerIndex].uppercased())
            .alert(isPresented: $isShowingAlert, content: {
                Alert(title: Text(messageTitle),
                      dismissButton: .default(Text("Continue"), action: {
                        self.askQuestion()
                }))
            })
        }
    }
    
    private func flagTappedAtIndex(_ index: Int) {
        if index == answerIndex {
            //Right answer
            messageTitle = "Right Answer"
            score += 1
        } else {
            // Wrong answer
            messageTitle = "Wrong Answer"
            score -= 1
        }
        isShowingAlert = true
    }
    private func askQuestion() {
        countries = countries.shuffled()
        answerIndex = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
