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
                        HStack(spacing: isEditing ? -25 : -69) {
                            Button(action: {
                                guard isEditing else { return }
                                isShowingPhotoLibrary = true
                            }, label: {
                                Image(systemName: "camera.on.rectangle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 16)
                                    .scaledToFit()
                            })
                            .frame(width: 69, height: 64, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            Image(uiImage: viewStore.image!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(25)
                                .shadow(radius: 5)
                            
                        }
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
                            Image(systemName: isDisclosed ? "minus" : "info.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding([.top, .trailing], 12)
                        })
                        .frame(width: 44, height: 44, alignment: .center)
                        .foregroundColor(.blue)
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

struct BeerCardView_Previews: PreviewProvider {
    static var previews: some View {
        BeerCardView(store: Store(initialState: Beer.mocks.first!,
                                  reducer: beerReducer,
                                  environment: BeerListEnvironment()))
            .frame(height: 144.0)
        
    }
}
