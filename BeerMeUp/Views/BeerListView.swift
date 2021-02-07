import SwiftUI
import ComposableArchitecture

struct BeerListEnvironment { }

struct BeerListState: Equatable {
    var beers: [Beer] = Beer.mocks
}

enum BeerListActions {
    case beer(index: Int, action: BeerActions)
    case addBeer
    case delete(id: UUID)
}

let beerListReducer = Reducer<BeerListState, BeerListActions, BeerListEnvironment>.combine(
    beerReducer.forEach(
        state: \BeerListState.beers,
        action: /BeerListActions.beer(index:action:),
        environment: { _ in BeerListEnvironment() }
    ), Reducer { state, action, environment in
        switch action {
        case .addBeer:
            state.beers.insert(.init(name: "Untitled Beer",
                                     image: UIImage(named: "default"),
                                     hops: -1,
                                     malt: -1),
                               at: 0)
        case .beer(_, _):
            break
        case .delete(let id):
            state.beers.removeAll(where: { $0.id == id})
            break
        }
        return .none
    }
)

struct BeerListView: View {
    let store: Store<BeerListState, BeerListActions>
    @State var isDeleting = false
    
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                ScrollView {
                    VStack {
                        ForEachStore(
                            store.scope(state: \.beers,
                                        action: BeerListActions.beer(index:action:)),
                            content: { s in
                                BeerCardListView(beerListStore: viewStore,
                                                 beerStore: s,
                                                 isDeleting: $isDeleting)
                            })
                    }
                    .padding(.top, 12)
                }
                .navigationTitle("Beers")
                .navigationBarItems(
                    leading: Button(action: {
                        withAnimation(.spring(response: 0.3,
                                              dampingFraction: 0.6,
                                              blendDuration: 0.5)) {
                            isDeleting.toggle()
                        }
                    }, label: {
                        Text(isDeleting ? "Done": "Edit")
                    }),
                    trailing: Button(action: {
                        withAnimation(.spring(response: 0.3,
                                              dampingFraction: 0.6,
                                              blendDuration: 0.5)) {
                            viewStore.send(.addBeer)
                        }
                    }, label: {
                        Text("Add")
                    }))
            }
        }
    }
}

struct BeerCardListView: View {
    var beerListStore: ViewStore<BeerListState, BeerListActions>
    var beerStore: Store<Beer, BeerActions>
    @Binding var isDeleting: Bool
    
    var body: some View {
        WithViewStore(beerStore) { viewStore in
            HStack {
                if isDeleting {
                    Button(action: {
                        withAnimation(.spring(response: 0.3,
                                              dampingFraction: 0.6,
                                              blendDuration: 0.5)) {
                            beerListStore.send(.delete(id: viewStore.id))
                        }
                    }, label: {
                        Text("Delete")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.trailing, 21)
                    }).frame(minWidth: 0,
                             maxWidth: 128,
                             maxHeight: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(20.0)
                    .padding(.trailing, -42)
                    .zIndex(-1)
                }
                BeerCardView(store: beerStore)
                    .padding(.trailing, isDeleting ? -86 : 0)
            }
            .padding([.leading, .trailing, .bottom], 12)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BeerListView(store: Store(initialState: BeerListState(beers: Beer.mocks),
                                  reducer: beerListReducer,
                                  environment: BeerListEnvironment())
        )
    }
}
