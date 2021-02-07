//
//  BeerPropertiesView.swift
//  BeerMeUp
//
//  Created by Guilherme Paciulli on 07/02/21.
//

import ComposableArchitecture
import SwiftUI

struct BeerPropertiesView: View {
    @Binding var isEditing: Bool
    var store: Store<Beer, BeerActions>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if !isEditing {
                    Text(viewStore.name)
                        .padding(12)
                        .font(.system(size: 18,
                                      weight: .light,
                                      design: .rounded))
                } else {
                    TextField(viewStore.name,
                              text: viewStore.binding(
                                get: \.name,
                                send: BeerActions.renameBeer))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 18,
                                      weight: .light,
                                      design: .rounded))
                        
                        .padding(12)
                        .allowsHitTesting(isEditing)
                }
                HStack {
                    Text("Hops")
                        .font(.system(size: 18, weight: .light))
                    BeerSliderView(isEditing: $isEditing,
                                   currentValue:
                                    viewStore.binding(get: \.hops,
                                                      send: BeerActions.updateHops),
                                   activeColor: Color.green, image: .hop)
                }.padding([.leading, .trailing], 12)
                .frame(height: 44)
                HStack {
                    Text("Malt  ")
                        .font(.system(size: 18, weight: .light))
                    BeerSliderView(isEditing: $isEditing,
                                   currentValue:
                                    viewStore.binding(
                                        get: \.malt,
                                        send: BeerActions.updateMalts),
                                   activeColor: Color.yellow, image: .malt)
                }.padding([.leading, .trailing], 12)
                .frame(height: 44)
                BeerEditingButtons(isEditing: $isEditing, store: store)
            }
        }
    }
}

struct BeerPropertiesView_Previews: PreviewProvider {
    @State static var isEditing = false
    static var previews: some View {
        BeerPropertiesView(isEditing: $isEditing,
                           store:
                            Store(
                                initialState: Beer.mocks.first!,
                                reducer: beerReducer,
                                environment: BeerListEnvironment()
                            )
        ).frame(height: 144.0)
    }
}
