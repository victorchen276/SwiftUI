//
//  HomeView.swift
//  CryptoApp
//
//  Created by Chen Yue on 17/04/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var currentCoin = "BTC"
    @Namespace var animation
    @StateObject var appModel: AppViewModel = AppViewModel()
    
    var body: some View {
        VStack {
            if let coins = appModel.coins, let coin = appModel.currentCoin {
                HStack(spacing: 15) {
                    Circle()
                        .fill(.red)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bitcoin")
                            .font(.callout)
                        Text("BTC")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity,
    //                   maxHeight: .infinity,
                       alignment: .leading)

                CustomControl()
                GraphView(coin: coin)
                Controls()
            } else {
                ProgressView()
                    .tint(Color.green)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    @ViewBuilder
    func GraphView(coin: CryptoModel) -> some View {
        GeometryReader { _ in
            LineGraphView(data: coin.last_7days_price.price)
        }
//        ScrollView(.horizontal, showsIndicators: true) {
//            ForEach(0..<30, id: \.self){ _ in
//                                            Text("Text Text").foregroundColor(Color.black)
//                                    }
//        }
//        .background(Color(UIColor.red))
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 30)
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func CustomControl() -> some View {
        let coins = ["BTC", "ETH", "BNB"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(coins, id: \.self) { coin in
                    Text(coin)
                        .foregroundColor(currentCoin == coin ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
//                        .background(.gray.opacity(0.5), in: Capsule())
                        .background {
                            if currentCoin == coin {
                                RoundedRectangle(cornerRadius: 5,
                                          style: .continuous)
                                    .fill(Color.gray.opacity(0.5))
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation{ currentCoin = coin }
                        }
                }
            }
            
        }
        .background {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    func Controls() -> some View {
        HStack(spacing: 20) {
            Button{
                
            } label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth:.infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.white)
                    }
            }
            Button{
                
            } label: {
                Text("Buy")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth:.infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.green)
                    }
            }
        }

    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
