//
//  BeerSliderView.swift
//  BeerMeUp
//
//  Created by Guilherme Paciulli on 06/02/21.
//

import SwiftUI

struct BeerSliderView: View {
    @Binding var isEditing: Bool
    @Binding var currentValue: Int
    let activeColor: Color
    let image: UIImage
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0...4, id: \.self) { index in
                BeerSliderUnitView(
                    isEditing: $isEditing,
                    currentValue: $currentValue,
                    activeColor: activeColor,
                    image: image,
                    index: index
                )
            }.padding([.leading, .trailing], 4)
        }
    }
}

struct BeerSliderUnitView: View {
    @Binding var isEditing: Bool
    @Binding var currentValue: Int
    let activeColor: Color
    let image: UIImage
    let index: Int
    var colorForIndex: Color {
        index <= currentValue ?
            activeColor :
            Color(.lightGray)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(colorForIndex,
                              lineWidth: 2.5)
                .foregroundColor(Color.clear)
            Image(uiImage: image.withRenderingMode(.alwaysTemplate))
                .resizable()
                .scaledToFit()
                .padding(8)
                .foregroundColor(colorForIndex)
        }
        .onTapGesture {
            guard isEditing  else { return }
            withAnimation(.spring()) {
                currentValue = index
            }
        }
    }
}

struct BeerSliderView_Previews: PreviewProvider {
    @State static var isEditing = true
    @State static var currentValue = 3
    
    static var previews: some View {
        BeerSliderView(
            isEditing: $isEditing,
            currentValue: $currentValue,
            activeColor: Color.green,
            image: .hop
        ).frame(height: 256)
    }
}
