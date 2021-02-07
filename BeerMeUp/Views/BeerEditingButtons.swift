//
//  BeerEditingButtons.swift
//  BeerMeUp
//
//  Created by Guilherme Paciulli on 07/02/21.
//

import ComposableArchitecture
import SwiftUI

struct BeerEditingButtons: View {
    @Binding var isEditing: Bool
    var store: Store<Beer, BeerActions>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation(
                        .spring(response: 0.3,
                                dampingFraction: 0.6,
                                blendDuration: 0.5)) {
                        isEditing.toggle()
                    }
                }, label: {
                    Text(isEditing ? "Save" : "Edit")
                        .font(.system(size: 18, weight: .light))
                }).frame(minWidth: 0,
                         maxWidth: .infinity,
                         minHeight: 44)
                .foregroundColor(.white)
                .background(isEditing ? Color.green : Color.blue)
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            }
        }
    }
}

struct BeerEditingButtons_Previews: PreviewProvider {
    @State static var isEditing = false

    static var previews: some View {
        BeerEditingButtons(isEditing: $isEditing,
                           store:
                            Store(
                                initialState: Beer.mocks.first!,
                                reducer: beerReducer,
                                environment: BeerListEnvironment()
                            )
        ).frame(height: 144.0)
    }
}
