//
//  HomeView.swift
//  LineGraph
//
//  Created by Chen Yue on 18/04/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "slider.vertical.3")
                        .font(.title2)
                }
                Spacer()
                Button {
                    debugPrint("aaaa")
                } label: {
                    Image("Dog")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.gray, lineWidth: 1)
                        }
                        .shadow(radius: 7)
                }
            }
            .padding()
            .foregroundColor(.black)
            
            VStack(spacing: 10) {
                Text("Total Balance")
                    .fontWeight(.bold)
                Text("$ 51 200")
                    .font(.system(size: 38, weight: .bold))
            }
            .padding(.top, 20)
            Button {
                
            } label: {
                HStack(spacing: 5) {
                    Text("Income")
                    Image(systemName: "chevron.down")
                }
                .font(.caption.bold())
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.white, in: Capsule())
                .foregroundColor(.black)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.03), radius: 5, x: -5, y: -5)
            }
            
            LineGraphView(data: samplePlot)
                .frame(maxWidth: .infinity, maxHeight: 250)
//                .background(Color.blue)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("BG"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

let samplePlot: [CGFloat] = [989, 1200, 750, 790, 650, 950, 1200, 600, 500, 600, 890, 1203, 1400, 900, 1250, 1600, 1200]
