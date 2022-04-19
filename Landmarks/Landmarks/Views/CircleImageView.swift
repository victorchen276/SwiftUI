//
//  CircleImage.swift
//  Landmarks
//
//  Created by Chen Yue on 17/04/22.
//

import SwiftUI

struct CircleImageView: View {
    
    var image: Image
    
    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(color: .gray, radius: 5, x: 0, y: 0)
//        Color.gray
//            .ignoresSafeArea(.container) // Ignore just for the color
//               .overlay(
//                   VStack(spacing: 20) {
//                       Text("Overlay").font(.largeTitle)
//                       Text("Example").font(.title).foregroundColor(.white)
//               })
       
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView(image: Image("turtlerock"))
    }
}
