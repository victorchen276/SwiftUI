//
//  ContentView.swift
//  CryptoApp
//
//  Created by Chen Yue on 17/04/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       HomeView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
