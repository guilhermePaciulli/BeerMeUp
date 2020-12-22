import SwiftUI
import ComposableArchitecture

enum BeerActions {
    case renameBeer(String)
    case updateHops(Int)
    case updateMalts(Int)
    case updateImage(UIImage?)
}

let beerReducer = Reducer<Beer, BeerActions, BeerListEnvironment> {
    state, action, environment in
    switch action {
    case .renameBeer(let text):
        state.name = text
    case .updateHops(let val):
        state.hops = val
    case .updateMalts(let val):
        state.malt = val
    case .updateImage(let img):
        guard let img = img else { return .none }
        state.image = img
    }
    return .none
}

struct BeerCardView: View {
    var store: Store<Beer, BeerActions>
    @State private var isDisclosed = false
    @State private var isEditing = false
    @State private var isShowingPhotoLibrary = false
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ZStack(alignment: .topTrailing) {
                    HStack {
                        if isDisclosed { Spacer() }
                        ZStack {
                            Button(action: {
                                guard isEditing else { return }
                                isShowingPhotoLibrary = true
                            }, label: {
                                Image(uiImage: isEditing ?
                                        UIImage(systemName: "camera.on.rectangle.fill")! :
                                        viewStore.image!)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(isEditing ? .init(white: 0.4) : .none)
                                    .padding(isEditing ? 32 : 0)
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .shadow(radius: 5)
                            })

                        }
                        .rotation3DEffect(
                            isEditing ? .init(degrees: 180) : .zero,
                            axis: (x: 0.0, y: 1.0, z: 0.0))
                        if isDisclosed {
                            Spacer()
                        } else {
                            Text(viewStore.name)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity,
                                       minHeight: 0,
                                       maxHeight: .infinity)
                        }
                    }
                    if !isEditing {
                        Button(action: {
                            withAnimation(.spring(response: 0.3,
                                                  dampingFraction: 0.6,
                                                  blendDuration: 0.5)) {
                                if isEditing { isEditing = false }
                                isDisclosed.toggle()
                            }
                        }, label: {
                            Image(systemName: isDisclosed ? "minus" : "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding([.top, .trailing], 12)
                        })
                        .frame(width: 44, height: 44, alignment: .center)
                        .foregroundColor(.init(white: 0.4))
                    }
                }
                if isDisclosed {
                    BeerPropertiesView(isEditing: $isEditing, store: store)
                }
            }
            .background(Color.init(.secondarySystemBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
            .sheet(isPresented: $isShowingPhotoLibrary) {
                isShowingPhotoLibrary = false
            } content: {
                ImagePicker(sourceType: .photoLibrary,
                            isShown: $isShowingPhotoLibrary,
                            uiImage: viewStore.binding(
                                get: \.image,
                                send: BeerActions.updateImage))
            }
        }
    }
}

struct BeerPropertiesView: View {
    @Binding var isEditing: Bool
    var store: Store<Beer, BeerActions>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TextField(viewStore.name,
                          text: viewStore.binding(
                            get: \.name,
                            send: BeerActions.renameBeer))
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .padding([.leading, .top, .bottom])
                    .allowsHitTesting(isEditing)
                HStack {
                    Text("Hops")
                        .font(.system(size: 18, weight: .semibold))
                    BeerSliderView(isEditing: $isEditing,
                                   currentValue:
                                    viewStore.binding(get: \.hops,
                                                      send: BeerActions.updateHops),
                                   activeColor: Color.green)
                }.padding([.leading, .trailing], 12)
                HStack {
                    Text("Malt  ")
                        .font(.system(size: 18, weight: .semibold))
                    BeerSliderView(isEditing: $isEditing,
                                   currentValue:
                                    viewStore.binding(
                                        get: \.malt,
                                        send: BeerActions.updateMalts),
                                   activeColor: Color.yellow)
                }.padding([.leading, .trailing], 12)
                BeerEditingButtons(isEditing: $isEditing, store: store)
            }
        }
    }
}

struct BeerEditingButtons: View {
    @Binding var isEditing: Bool
    var store: Store<Beer, BeerActions>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isEditing.toggle()
                    }
                }, label: {
                    Text(isEditing ? "Save" : "Edit")
                        .font(.system(size: 18, weight: .bold))
                }).frame(minWidth: 0,
                         maxWidth: .infinity,
                         minHeight: 44)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(20, corners: [.bottomLeft])
            }
        }
    }
}

struct BeerSliderView: View {
    @Binding var isEditing: Bool
    @Binding var currentValue: Int
    let activeColor: Color
    
    var body: some View {
        HStack {
            ForEach(0...4, id: \.self) { index in
                RoundedRectangle(cornerRadius: isEditing ? 10 : .infinity)
                    .fill(index <= currentValue ?
                            activeColor :
                            Color.init(.lightGray))
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: isEditing ? 44 : 12)
                    .onTapGesture {
                        currentValue = index
                    }
            }
        }.padding([.leading, .trailing], 12)
    }
}

struct BeerCardView_Previews: PreviewProvider {
    static var previews: some View {
        BeerCardView(store: Store(initialState: Beer.mocks.first!,
                                  reducer: beerReducer,
                                  environment: BeerListEnvironment()))
            .frame(height: 144.0)
        
    }
}
