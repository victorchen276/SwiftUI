//
//  HomeView.swift
//  CryptoApp
//
//  Created by Chen Yue on 17/04/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @State var currentCoin = "BTC"
    @Namespace var animation
    @StateObject var appModel: AppViewModel = AppViewModel()
    
    var body: some View {
        VStack {
            if let coins = appModel.coins, let coin = appModel.currentCoin {
                HStack(spacing: 15) {
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
//                        .overlay { Circle().stroke(.white, lineWidth: 1) }
//                        .shadow(color: .white.opacity(0.5), radius: 7, x: 0, y: 0)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bitcoin")
                            .font(.callout)
                        Text("BTC")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                CustomControl(coins: coins)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(coin.current_price.convertToCurrency())
                        .font(.largeTitle.bold())
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(coin.price_change < 0 ? .white : .black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Capsule()
                                .fill(coin.price_change < 0 ? .red : Color.green)
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
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
            LineGraphView(data: coin.last_7days_price.price, profit: coin.price_change > 0)
        }
        .padding(.vertical, 30)
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func CustomControl(coins: [CryptoModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(coins) { coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
//                        .background(.gray.opacity(0.5), in: Capsule())
                        .background {
                            if currentCoin == coin.symbol.uppercased() {
                                RoundedRectangle(cornerRadius: 5,
                                          style: .continuous)
                                    .fill(Color.gray.opacity(0.5))
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            appModel.currentCoin = coin
                            withAnimation{ currentCoin = coin.symbol.uppercased() }
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

extension Double {
    
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: .init(value: self)) ?? ""
    }
    
}
