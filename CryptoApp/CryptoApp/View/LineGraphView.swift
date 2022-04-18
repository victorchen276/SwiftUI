//
//  LineGraphView.swift
//  LineGraph
//
//  Created by Chen Yue on 18/04/22.
//

import SwiftUI

struct LineGraphView: View {
    
    var data: [Double]
    var profit: Bool = false
    
    @State var currentPolt = ""
    @State var offset: CGSize = .zero
    @State var showPlot: Bool = false
    @State var translation: CGFloat = 0
    
    @GestureState var isDrag: Bool = false
    
    @State var graphProgress: CGFloat = 0
    
    var body: some View {
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
            AnimatedGraphPath(progress: graphProgress, points: points)
            .fill(
                LinearGradient(colors: [
                    profit ? Color.green : Color.red,
                    profit ? Color.green : Color.red,
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
                .opacity(graphProgress)
            }
            .overlay(alignment: .bottomLeading, content: {
                //Drag indicator
                VStack(spacing: 0) {
                    Text(currentPolt)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .frame(width: 100)
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
                currentPolt = data[index].convertToCurrency()
                self.translation = translation
                //removing half width
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            }).onEnded({ value in
                withAnimation { showPlot = false }
            }).updating($isDrag, body: { value, out, _ in
                out = true
            }))
        }
        .overlay(
            VStack(alignment: .leading) {
                let max = data.max() ?? 0
                let min = data.min() ?? 0
                Text(max.convertToCurrency())
                    .font(.caption.bold())
                    .offset(y: -5)
                Spacer()
                VStack {
                    Text(min.convertToCurrency())
                        .font(.caption.bold())
                    Text("Last 7 Days")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .offset(y: 15)
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal, 10)
        .onChange(of: isDrag) { newValue in
            if !isDrag{ showPlot = false }
        }
        .onAppear {
            drawPolt()
        }
        .onChange(of: data) { newValue in
            drawPolt()
        }
    }
    
    private func drawPolt() {
        graphProgress = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 1.2)) {
                graphProgress = 1
            }
        }
    }
    
    @ViewBuilder
    func FillBG() -> some View {
        let color = profit ? Color.green : Color.red
        LinearGradient(colors: [
            color.opacity(0.3),
            color.opacity(0.2),
            color.opacity(0.1)]
                       + Array(repeating: color.opacity(0.1), count: 2)
                       , startPoint: .top,endPoint: .bottom)
    }
    
}

struct LineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AnimatedGraphPath: Shape {
    
    var progress: CGFloat
    var points: [CGPoint]
    var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }
    
}
