//
//  DetailView.swift
//  SwiftUI1
//
//  Created by Sauvik Dolui on 15/10/20.
//

import SwiftUI



struct DetailView: View {
    @State private var hideNavigationBar = false
    var selectedImage: String
    var body: some View {
        Image(uiImage: UIImage(named: selectedImage)!)
            .resizable()
            .aspectRatio(1024/768, contentMode: .fit)
            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                hideNavigationBar.toggle()
            })
            .navigationBarTitle(selectedImage, displayMode: .inline)
            .navigationBarHidden(hideNavigationBar)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedImage: "nssl0049")
    }
}
