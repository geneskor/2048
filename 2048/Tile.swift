import Foundation

struct Tile: Identifiable, Equatable {
    let id = UUID()
    var value: Int
    var isNew: Bool = false

    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.value == rhs.value && lhs.isNew == rhs.isNew
    }
}
