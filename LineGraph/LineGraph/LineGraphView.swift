//
//  LineGraphView.swift
//  LineGraph
//
//  Created by Chen Yue on 18/04/22.
//

import SwiftUI

struct LineGraphView: View {
    
    var data: [CGFloat]
    @State var currentPolt = ""
    @State var offset: CGSize = .zero
    var body: some View {
//        let array = Array(repeating: Color.red.opacity(0.1), count: 4) + Array(repeating: Color.clear, count: 2)
        
        
        
        GeometryReader { proxy in
            ZStack {
                let height = proxy.size.height
                let width = proxy.size.width / CGFloat(data.count-1)
                let maxPoint = (data.max() ?? 0) + 100
                let points: [CGPoint] = data.enumerated().compactMap { item in
                    let progress = item.element / maxPoint
                    let pathHeight = progress * height
                    let pathWidth = width * CGFloat(item.offset)
                    return CGPoint(x: pathWidth, y: -pathHeight + height)
                }
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(colors: [
                        Color.gray,
                        Color.black
                    ], startPoint: .leading, endPoint: .trailing)
                )
//                LinearGradient(colors: [
//                    Color.red.opacity(0.3),
//                    Color.red.opacity(0.2),
//                    Color.red.opacity(0.1)]
//                               + Array(repeating: Color.clear, count: 2)
//                               , startPoint: .top,endPoint: .bottom)
                FillBG()
                .clipShape(
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLines(points)
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                )
//                .padding(.top, 15)
                
            }
            .overlay(
                //Drag indicator
                VStack(spacing: 0) {
                    Text(currentPolt)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.red, in: Capsule())
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 1, height: 45)
                }
            )
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func FillBG() -> some View {
        LinearGradient(colors: [
            Color.black.opacity(0.3),
            Color.gray.opacity(0.2),
            Color.gray.opacity(0.1)]
                       + Array(repeating: Color.clear, count: 2)
                       , startPoint: .top,endPoint: .bottom)
    }
    
}

struct LineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
