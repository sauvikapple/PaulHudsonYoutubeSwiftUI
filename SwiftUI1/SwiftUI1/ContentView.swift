//
//  ContentView.swift
//  SwiftUI1
//
//  Created by Sauvik Dolui on 15/10/20.
//

import SwiftUI
import Combine

class DataSource: ObservableObject {
    @Published var didChange = PassthroughSubject<Void, Never>()
    var pictures: [String] = []
    init() {
        let fm = FileManager.default
        if let resourcePath = Bundle.main.resourcePath,
           let contents = try? fm.contentsOfDirectory(atPath: resourcePath) {
            pictures = contents.filter { $0.hasPrefix("nssl") }
        }
    }
}

struct ContentView: View {
    @ObservedObject var dataSource = DataSource()
    var body: some View {
        NavigationView {
            List(dataSource.pictures, id: \.self) {
                NavigationLink($0, destination: DetailView(selectedImage: $0))
            }.navigationTitle(
                Text("Storm Viewer")
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
