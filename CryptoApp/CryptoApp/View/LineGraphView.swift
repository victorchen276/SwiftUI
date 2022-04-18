//
//  LineGraphView.swift
//  LineGraph
//
//  Created by Chen Yue on 18/04/22.
//

import SwiftUI

struct LineGraphView: View {
    
    var data: [Double]
    @State var currentPolt = ""
    @State var offset: CGSize = .zero
    @State var showPlot: Bool = false
    @State var translation: CGFloat = 0
    
    var body: some View {
//        let array = Array(repeating: Color.red.opacity(0.1), count: 4) + Array(repeating: Color.clear, count: 2)
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = proxy.size.width / CGFloat(data.count-1)
            let maxPoint = data.max() ?? 0
            let minPoint = data.min() ?? 0
            let points: [CGPoint] = data.enumerated().compactMap { item in
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                let pathHeight = progress * (height - 50)
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
            
            ZStack {
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
            .overlay(alignment: .bottomLeading, content: {
                //Drag indicator
                VStack(spacing: 0) {
                    Text(currentPolt)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.red, in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    Rectangle()
                        .fill(.red)
                        .frame(width: 1, height: 40)
                        .padding(.top)
                        
                    Circle()
                        .fill(.red)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        )
                    Rectangle()
                        .fill(.red)
                        .frame(width: 1, height: 50)
                }
                .frame(width: 80, height: 170)
                .offset(y: 70)
                .offset(offset)
                .opacity(showPlot ? 1 : 0)
            })
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation { showPlot = true }
                //why need 40?!
                let translation = value.location.x
                let index = max(min(Int((translation/width).rounded() + 1), data.count - 1), 0)
                currentPolt = "$ \(data[index])"
                self.translation = translation
                //removing half width
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            }).onEnded({ value in
                withAnimation { showPlot = false }
            }))
        }
        .overlay(
            VStack(alignment: .leading) {
                let max = data.max() ?? 0
                Text("$ \(Int(max))")
                    .font(.caption.bold())
                Spacer()
                Text("$ 0")
                    .font(.caption.bold())
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
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
