import Foundation

struct CustodyDay: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var parent: String
    var isSwap: Bool
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), parent: String = "", isSwap: Bool = false, notes: String = "") {
        self.id = id
        self.date = date
        self.parent = parent
        self.isSwap = isSwap
        self.notes = notes
    }
}
