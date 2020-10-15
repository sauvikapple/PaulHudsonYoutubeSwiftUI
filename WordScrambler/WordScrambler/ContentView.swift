//
//  ContentView.swift
//  WordScrambler
//
//  Created by Sauvik Dolui on 16/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var gameWord = ""
    @State private var newWord = ""
    @State private var usedWords = [String]()
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $newWord) { isEditingDone in
                    print("On Editing Done \(isEditingDone)")
                } onCommit: {
                    print("onCommit")
                    UIApplication.shared.windows.first?.endEditing(true)
                    addNewWord(newWord)
                }
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                List(usedWords, id:\.self) { word in
                    Text(word)
                }
            }.navigationTitle(gameWord)
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .onAppear {
                startGame()
            }
        }
    }
    
    // MARK: - Helper Functions
    func startGame() {
        if let wordFilePath = Bundle.main.url(forResource: "start", withExtension: "txt"),
           let fileContent = try? String(contentsOf: wordFilePath) {
            let words = fileContent.components(separatedBy: "\n")
            gameWord = words.randomElement() ?? "blueblur"
            return
        }
        fatalError("Could not load game word resource file")
    }
    func isNew(word: String) -> Bool {
        usedWords.contains(word) == false
    }
    func isPossible(userWord: String, gameWord: String) -> Bool {
        let userWorkLower = userWord.lowercased()
        var gameWordLower = gameWord.lowercased()
        
        for letter in userWorkLower {
            if let rangeOfLetter = gameWordLower.range(of: String(letter)) {
                gameWordLower.remove(at: rangeOfLetter.lowerBound)
            } else {
                // Letter was not found in game word, return false
                return false
            }
        }
        return true
    }
    func isValidEnglishWord(_ word: String) -> Bool {
        let textChecker = UITextChecker()
        let misSpelledLoc = textChecker.rangeOfMisspelledWord(in: word,
                              range: NSRange(location: 0, length: word.utf16.count),
                              startingAt: 0,
                              wrap: false,
                              language: "end")
        return misSpelledLoc.location == NSNotFound
    }
    func addNewWord(_ word: String) {
        // 1. Check if it's already used
        guard isNew(word: word) else {
            showAlert(title: "NO NO", message: "You have already tried \(word)")
            return
        }
        
        // 2. Check is possible from Game Word
        guard isPossible(userWord: word, gameWord: gameWord) else {
            showAlert(title: "Huh!~", message: "Word not possible from \(gameWord)")
            return
        }
        
        // 3. Is a dictionary valid word?
        guard isValidEnglishWord(word) else {
            showAlert(title: "Boom!", message: "Word is not a valid one")
            return
        }
        // All looks fine, let's add this in used word array and clear current word
        usedWords.insert(word, at: 0) // insert at very first, word will be top in list
        newWord = ""
    }
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isShowingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
