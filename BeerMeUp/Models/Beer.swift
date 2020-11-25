import UIKit

struct Beer: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var image: UIImage?
    var hops: Int
    var malt: Int
}

extension Beer {
    static var mocks: [Beer] {
        [
            Beer(name: "Brahma",
                 image: UIImage(named: "brahma")!,
                 hops: 2,
                 malt: 1),
            Beer(name: "Skol",
                 image: UIImage(named: "skol")!,
                 hops: 3,
                 malt: 2),
            Beer(name: "Heineken",
                 image: UIImage(named: "heineken")!,
                 hops: 4,
                 malt: 5)
        ]
    }
}
