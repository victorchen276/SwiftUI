//
//  ContentView.swift
//  Tabbar
//
//  Created by Chen Yue on 5/06/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTab: Tab = .tab1
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                Text("Tab1")
                    .applyBackgroundColor()
                    .tag(Tab.tab1)
                Text("Tab2")
                    .applyBackgroundColor()
                    .tag(Tab.tab2)
                Text("Tab3")
                    .applyBackgroundColor()
                    .tag(Tab.tab3)
                Text("Tab4")
                    .applyBackgroundColor()
                    .tag(Tab.tab4)
            }
            CustomTabBar(currentTab: $currentTab)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

extension View {
    
    func applyBackgroundColor() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.blue
                    .ignoresSafeArea()
            }
    }
    
}
