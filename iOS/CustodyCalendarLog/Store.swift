import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [CustodyDay] = []
    @Published var isPro: Bool = false

    static let freeLimit = 200

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("custodylog_items.json")
        load()
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= Store.freeLimit
    }

    func add(_ item: CustodyDay) -> Bool {
        guard !isAtFreeLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: CustodyDay) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: CustodyDay) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([CustodyDay].self, from: data) else {
            items = [
        CustodyDay(date: Calendar.current.date(byAdding: .day, value: -0, to: Date()) ?? Date(), parent: "Sample Parent 1", isSwap: false, notes: "Sample Notes 1"),
        CustodyDay(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), parent: "Sample Parent 2", isSwap: true, notes: "Sample Notes 2"),
        CustodyDay(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), parent: "Sample Parent 3", isSwap: false, notes: "Sample Notes 3")
            ]
            save()
            return
        }
        items = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
