import SwiftUI
import ComposableArchitecture

struct BeerListEnvironment { }

struct BeerListState: Equatable {
    var beers: [Beer] = Beer.mocks
}

enum BeerListActions {
    case beer(index: Int, action: BeerActions)
}

let beerListReducer = Reducer<BeerListState, BeerListActions, BeerListEnvironment>.combine(
    beerReducer.forEach(
        state: \BeerListState.beers,
        action: /BeerListActions.beer(index:action:),
        environment: { _ in BeerListEnvironment() }
    ), Reducer { state, action, environment in
        return .none
    }
)

struct BeerListView: View {
    let store: Store<BeerListState, BeerListActions>
    
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                ScrollView {
                    VStack {
                        ForEachStore(
                            store.scope(state: \.beers, action: BeerListActions.beer(index:action:)),
                            content: BeerCardView.init(store:)
                        )
                    }
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Beers")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BeerListView(store: Store(initialState:
                                    BeerListState(beers: Beer.mocks),
                                  reducer: beerListReducer,
                                  environment: BeerListEnvironment())
        )
    }
}
